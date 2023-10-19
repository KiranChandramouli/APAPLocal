* @ValidationCode : MjoxMzk4NzQxNDA3OkNwMTI1MjoxNjgxMzc5Mzg5MDgxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:19:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
