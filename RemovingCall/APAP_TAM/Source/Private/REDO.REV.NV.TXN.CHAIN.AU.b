* @ValidationCode : MjoxMzk4NzQxNDA3OkNwMTI1MjoxNjg0ODQyMTI5ODA0OklUU1M6LTE6LTE6NzU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 75
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
SUBROUTINE REDO.REV.NV.TXN.CHAIN.AU(Y.DATA)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

OPENFILES:

    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC = ''
    CALL OPF(FN.RTC,F.RTC)

RETURN

PROCESS:


    LOCATE '@ID' IN D.FIELDS SETTING POS THEN
        Y.ID =  'Y'
        Y.ID.VAL = D.RANGE.AND.VALUE<POS>
    END

    LOCATE 'TELLER.ID' IN D.FIELDS SETTING POS.TLR THEN
        Y.TEL.ID = 'Y'
        Y.TEL.VAL = D.RANGE.AND.VALUE<POS.TLR>
    END

    IF Y.ID EQ '' AND Y.TEL.ID EQ '' THEN
        ENQ.ERROR = 'EB-AUT.POR.REQ'
    END

    BEGIN CASE

        CASE Y.ID EQ 'Y'
            SEL.CMD = 'SELECT ':FN.RTC:' WITH TRANS.ID EQ "':Y.ID.VAL:'" AND TRANS.AUTH EQ "IR" AND TRANS.DATE EQ ':TODAY

        CASE Y.TEL.ID EQ 'Y'
            SEL.CMD = 'SELECT ':FN.RTC:' WITH TELLER.ID EQ "':Y.TEL.VAL:'" AND TRANS.AUTH EQ "IR" AND TRANS.DATE EQ ':TODAY

        CASE Y.ID EQ 'Y' AND Y.TEL.ID EQ 'Y'
            SEL.CMD = 'SELECT ':FN.RTC:' WITH TELLER.ID EQ "':Y.TEL.VAL:'" AND TRANS.ID EQ "':Y.ID.VAL:'" AND TRANS.AUTH EQ "IR" AND TRANS.DATE EQ ':TODAY

    END CASE

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    GOSUB PROCESS.RECS

RETURN

PROCESS.RECS:

    Y.DATA = SEL.LIST

RETURN

PGM.END:

END
