package com.example.jobtracker_pro

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingResult: MethodChannel.Result? = null
    private var pendingBytes: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "jobtracker/pdf")
            .setMethodCallHandler { call, result ->
                if (call.method != "savePdf") {
                    result.notImplemented()
                } else if (pendingResult != null) {
                    result.error("busy", "A save is already in progress", null)
                } else {
                    val bytes = call.argument<ByteArray>("bytes")
                    val filename = call.argument<String>("filename")
                    if (bytes == null || filename == null) {
                        result.error("invalid", "Missing PDF data", null)
                    } else {
                        pendingResult = result
                        pendingBytes = bytes
                        try {
                            val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                                addCategory(Intent.CATEGORY_OPENABLE)
                                type = "application/pdf"
                                putExtra(Intent.EXTRA_TITLE, filename)
                            }
                            startActivityForResult(intent, 4102)
                        } catch (error: Exception) {
                            pendingResult = null
                            pendingBytes = null
                            result.error("save_failed", error.message, null)
                        }
                    }
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != 4102) return
        val result = pendingResult ?: return
        val bytes = pendingBytes
        pendingResult = null
        pendingBytes = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null || bytes == null) {
            result.success(false)
            return
        }
        Thread {
            try {
                val stream = contentResolver.openOutputStream(uri)
                    ?: throw IllegalStateException("Cannot open destination")
                stream.use { it.write(bytes) }
                runOnUiThread { result.success(true) }
            } catch (error: Exception) {
                runOnUiThread { result.error("save_failed", error.message, null) }
            }
        }.start()
    }
}
