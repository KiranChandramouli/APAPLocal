* @ValidationCode : MjoxMTI4MDUzNTg5OlVURi04OjE3MDI5Nzc1MDMxMDI6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 14:48:23
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED, OFS GLOBUS MANAGER commented
*19-12-2023    Narmadha V          Manual R22 Conversion    Call Routine Format Modified
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.CREDIT.CARD.UPD(BULD.ID)

* Routine to update the REDO.APAP.CREDIT.CARD.DET table
* Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CREDIT.CARD.DET ;*R22 MANUAL CONVERSION
    $INSERT I_REDO.APAP.CREDIT.CARD.UPD.COMMON ;*R22 MANUAL CONVERSION
    $USING EB.Interface ;*Manual R22 Conversion


    GOSUB PROCESS
RETURN

PROCESS:
********

    YCARD.ID = ''; YLOGO = ''; YORG = ''; YDESCRIP = ''
    YCARD.ID = FIELD(BULD.ID,';',1)
    IF NOT(YCARD.ID) THEN
        RETURN
    END

    YCARD.ID = TRIM(YCARD.ID,'0',"L")

*IF LEN(YCARD.ID) LT '16' THEN
*PRINT "Record length is less than 16 character ":BULD.ID
*RETURN
*END

    YLOGO = FIELD(BULD.ID,';',2)
    YORG = FIELD(BULD.ID,';',3)
    YDESCRIP = FIELD(BULD.ID,';',4)

    ERR.REDO.APAP.CREDIT.CARD.DET = ''; R.REDO.APAP.CREDIT.CARD.DET = ''
    CALL F.READ(FN.REDO.APAP.CREDIT.CARD.DET,YCARD.ID,R.REDO.APAP.CREDIT.CARD.DET,F.REDO.APAP.CREDIT.CARD.DET,ERR.REDO.APAP.CREDIT.CARD.DET)
    R.REDO.APAP.CREDIT.CARD.DET<CRDT.CARD.CARD.LOGO> = YLOGO
    R.REDO.APAP.CREDIT.CARD.DET<CRDT.CARD.CARD.ORG> = YORG
    R.REDO.APAP.CREDIT.CARD.DET<CRDT.CARD.CARD.DESCRIPTION> = YDESCRIP

    OFS.SOURCE.ID = 'OFS.LOAD'
    APPLICATION.NAME = 'REDO.APAP.CREDIT.CARD.DET'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'REDO.APAP.CREDIT.CARD.DET,INP'
    NO.AUT = '0'
    OFS.MSG.ID = ''
    APPLICATION.ID = YCARD.ID
    OFS.POST.MSG = ''; TEMP.REST = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.REDO.APAP.CREDIT.CARD.DET,OFS.CARD)
    CRT OFS.CARD
    OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER('OFS.LOAD',OFS.CARD)
* CALL OFS.CALL.BULK.MANAGER('OFS.LOAD',OFS.CARD, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
    EB.Interface.OfsCallBulkManager('OFS.LOAD',OFS.CARD, OFS.RESP, TXN.COMMIT) ;*Manual R22 Conversion - Call Routine
    CRT OFS.CARD
    CALL JOURNAL.UPDATE('')

    DELETE F.SAVELST,SEL.REC
RETURN
END
