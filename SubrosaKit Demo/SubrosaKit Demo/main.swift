//
//  main.swift
//  SubrosaKit Demo
//
//  Created by Dimka Novikov on 09.03.2023.
//  Copyright © 2023 Exhausted Reality. All rights reserved.
//


// MARK: Import section

import Foundation
import SubrosaKit



// MARK: - SubrosaKitDemo

final class SubrosaKitDemo {

    // MARK: - Private properties

    private let plainText = """
Hello!
This is a test application that tests the SubrosaKit framework with different views.
Numbers outside Unicode table boundaries: \u{10FFFE} & \u{10FFFF}.
Emoji: 🤡😹.
"""

    private let aes = SBRConfidential(with: .aes(keySize: .bits256))
    private let eddsa = SBRConfidential(with: .eddsa(hashValue: .bits512, keySize: .bits256))
    private let sha2 = SBRConfidential(with: .sha2(hashValue: .bits512))



    // MARK: - Public methods

    func showSubrosaKitVersion() {
        let version = SBRKit.info.version
        let build = SBRKit.info.build


        print("SubrosaKit Specification {")
        print("  Version: \(version.major).\(version.minor).\(version.patch)")
        print("  Build: \(build)")
        print("}\n")
    }

    func showPlainText() {
        print("Plain text: \(plainText)\n")
    }

    func executeAES() {
        let startTime = CFAbsoluteTimeGetCurrent()

        let key = aes.generateKey()

        let encryptedData = aes.encrypt(propertySet: .init(text: plainText, key: key))!
        let decryptedText = aes.decrypt(propertySet: .init(data: encryptedData, key: key))!

        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime


        print("AES = {")
        print("   Encrypted text: \(String(data: encryptedData, encoding: .utf16)!)")
        print("   Decrypted text: \(decryptedText)")
        print("Time elapsed \(String(format: "%.05f", elapsedTime)) seconds")
        print("}\n")
    }

    func executeEdDSA() {
        let dogPlainText = "woof-woof-woof"
        let catPlainText = "meow-meow-meow"

        let catKeyPair = eddsa.generateKeyPair()!
        let dogKeyPair = eddsa.generateKeyPair()!

        let salt = eddsa.generateSalt()!

        // Cat's symmetric key
        let catSymmetricKey = eddsa.generateKey(
            with: .init(
                keyPair: .init(
                    privateKey: catKeyPair.privateKey,
                    publicKey: dogKeyPair.publicKey!
                ),
                salt: salt
            )
        )

        // Dog's symmetric key
        let dogSymmetricKey = eddsa.generateKey(
            with: .init(
                keyPair: .init(
                    privateKey: dogKeyPair.privateKey,
                    publicKey: catKeyPair.publicKey!
                ),
                salt: salt
            )
        )

        let encryptionStartTime = CFAbsoluteTimeGetCurrent()

        let catEncryptedData = eddsa.encrypt(propertySet: .init(text: catPlainText, key: catSymmetricKey))!
        let dogEncryptedData = eddsa.encrypt(propertySet: .init(text: dogPlainText, key: dogSymmetricKey))!

        let encryptionElapsedTime = CFAbsoluteTimeGetCurrent() - encryptionStartTime

        let decryptionStartTime = CFAbsoluteTimeGetCurrent()

        let catDecryptedText = eddsa.decrypt(propertySet: .init(data: dogEncryptedData, key: catSymmetricKey))!
        let dogDecryptedText = eddsa.decrypt(propertySet: .init(data: catEncryptedData, key: dogSymmetricKey))!

        let decryptionElapsedTime = CFAbsoluteTimeGetCurrent() - decryptionStartTime


        print("EdDSA = {")
        print("Checking:")
        print("   Generated salt: \(String(data: salt, encoding: .utf8)!)")
        print("   Is cat & dog has the same keys? - \((dogSymmetricKey == catSymmetricKey ? "Yes" : "No"))")
        print("Encryption:")
        print("      Cat's encrypted text: \(String(data: catEncryptedData, encoding: .utf16)!)")
        print("      Dog's encrypted text: \(String(data: dogEncryptedData, encoding: .utf16)!)")
        print("   Time elapsed \(String(format: "%.05f", encryptionElapsedTime)) seconds")
        print("- - - - - - - -")
        print("Decryption:")
        print("      Cat's decrypted text: \(catDecryptedText)")
        print("      Dog's decrypted text: \(dogDecryptedText)")
        print("   Time elapsed \(String(format: "%.05f", decryptionElapsedTime)) seconds")
        print("}\n")
    }

    func executeSHA2() {
        let startTime = CFAbsoluteTimeGetCurrent()

        let encryptedData = sha2.encrypt(propertySet: .init(text: plainText, computeType: .cpu))!

        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime


        print("SHA-2 = {")
        print("   Encrypted text: \(String(data: encryptedData, encoding: .utf8)!)")
        print("Time elapsed \(String(format: "%.05f", elapsedTime)) seconds")
        print("}\n")
    }
}



// MARK: - SubrosaKitDemo App Testing

let subrosaKitDemo = SubrosaKitDemo()

subrosaKitDemo.showSubrosaKitVersion()

subrosaKitDemo.showPlainText()

subrosaKitDemo.executeAES()
subrosaKitDemo.executeEdDSA()
subrosaKitDemo.executeSHA2()
