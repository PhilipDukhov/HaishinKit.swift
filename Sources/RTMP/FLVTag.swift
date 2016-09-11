import Foundation
import AVFoundation

// MARK: FLVVideoCodec
enum FLVVideoCodec: UInt8 {
    case sorensonH263 = 2
    case screen1      = 3
    case on2VP6       = 4
    case on2VP6Alpha  = 5
    case screen2      = 6
    case avc          = 7
    case unknown      = 0xFF

    var isSupported:Bool {
        switch self {
        case .sorensonH263:
            return false
        case .screen1:
            return false
        case .on2VP6:
            return false
        case .on2VP6Alpha:
            return false
        case .screen2:
            return false
        case .avc:
            return true
        case .unknown:
            return false
        }
    }
}

// MARK: - FLVFrameType
enum FLVFrameType: UInt8 {
    case key        = 1
    case inter      = 2
    case disposable = 3
    case generated  = 4
    case command    = 5
}

// MARK: - FLVAVCPacketType
enum FLVAVCPacketType:UInt8 {
    case seq = 0
    case nal = 1
    case eos = 2
}

// MARK: - FLVAACPacketType
enum FLVAACPacketType:UInt8 {
    case seq = 0
    case raw = 1
}

// MARK: - FLVSoundRate
enum FLVSoundRate:UInt8 {
    case kHz5_5 = 0
    case kHz11  = 1
    case kHz22  = 2
    case kHz44  = 3
    
    var floatValue:Float64 {
        switch self {
        case .kHz5_5:
            return 5500
        case .kHz11:
            return 11025
        case .kHz22:
            return 22050
        case .kHz44:
            return 44100
        }
    }
}

// MARK: - FLVSoundSize
enum FLVSoundSize:UInt8 {
    case snd8bit = 0
    case snd16bit = 1
}

// MARK: - FLVSoundType
enum FLVSoundType:UInt8 {
    case mono = 0
    case stereo = 1
}

// MARK: - FLVAudioCodec
enum FLVAudioCodec:UInt8 {
    case pcm           = 0
    case adpcm         = 1
    case mp3           = 2
    case pcmle         = 3
    case nellymoser16K = 4
    case nellymoser8K  = 5
    case nellymoser    = 6
    case g711A         = 7
    case g711MU        = 8
    case aac           = 10
    case speex         = 11
    case mp3_8k        = 14
    case unknown       = 0xFF
    
    var isSupported:Bool {
        switch self {
        case .pcm:
            return false
        case .adpcm:
            return false
        case .mp3:
            return false
        case .pcmle:
            return false
        case .nellymoser16K:
            return false
        case .nellymoser8K:
            return false
        case .nellymoser:
            return false
        case .g711A:
            return false
        case .g711MU:
            return false
        case .aac:
            return true
        case .speex:
            return false
        case .mp3_8k:
            return false
        case .unknown:
            return false
        }
    }
    
    var formatID:AudioFormatID {
        switch self {
        case .pcm:
            return kAudioFormatLinearPCM
        case .mp3:
            return kAudioFormatMPEGLayer3
        case .pcmle:
            return kAudioFormatLinearPCM
        case .aac:
            return kAudioFormatMPEG4AAC
        case .mp3_8k:
            return kAudioFormatMPEGLayer3
        default:
            return 0
        }
    }
    
    var headerSize:Int {
        switch self {
        case .aac:
            return 2
        default:
            return 1
        }
    }
}

// MARK: -
struct FLVTag {

    enum TagType: UInt8 {
        case audio = 8
        case video = 9
        case data  = 18

        var streamId:UInt16 {
            switch self {
            case .audio:
                return RTMPChunk.audio
            case .video:
                return RTMPChunk.video
            case .data:
                return 0
            }
        }
        
        var headerSize:Int {
            switch self {
            case .audio:
                return 2
            case .video:
                return 5
            case .data:
                return 0
            }
        }

        func createMessage(_ streamId: UInt32, timestamp: UInt32, buffer:Foundation.Data) -> RTMPMessage {
            switch self {
            case .audio:
                return RTMPAudioMessage(streamId: streamId, timestamp: timestamp, buffer: buffer)
            case .video:
                return RTMPVideoMessage(streamId: streamId, timestamp: timestamp, buffer: buffer)
            case .data:
                return RTMPDataMessage(objectEncoding: 0x00)
            }
        }
    }

    static let headerSize = 11

    var tagType:TagType = .data
    var dataSize:UInt32 = 0
    var timestamp:UInt32 = 0
    var timestampExtended:UInt8 = 0
    var streamId:UInt32 = 0
}

// MARK: CustomStringConvertible
extension FLVTag: CustomStringConvertible {
    var description:String {
        return Mirror(reflecting: self).description
    }
}

