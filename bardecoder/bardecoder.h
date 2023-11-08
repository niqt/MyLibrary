#ifndef BARDECODER_H
#define BARDECODER_H

#include <QObject>
#include <QtMultimedia/QVideoSink>
#include <QtMultimedia/QVideoFrame>
#include <qqml.h>
#include <QFuture>
#include "opencv2/opencv.hpp"

class Bardecoder : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QObject* videoSink WRITE setVideoSink)
    Q_PROPERTY(bool run WRITE setRun)
public:
    Bardecoder(QObject *parent = nullptr);
    ~Bardecoder();
    void setVideoSink(QObject *videoSink);
    bool isDecoding() {return m_decoding; }
    void setRun(bool run);

public slots:
    void setFrame(const QVideoFrame &frame);


signals:
    void videoSyncChnaged();
    void decoded(const QString &code);

private:
    QVideoSink *m_videoSink;
    cv::Ptr<cv::barcode::BarcodeDetector> m_bardet;
    QFuture<void> m_processThread;
    bool m_decoding;
    bool m_run;
};

#endif // BARDECODER_H
