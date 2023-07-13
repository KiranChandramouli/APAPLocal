* @ValidationCode : MjotMjQ2ODg1MDk4OkNwMTI1MjoxNjg5MjMxNDg5NzU2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 12:28:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.APAP.CUST.SWIFT.UPD

* One time routine update the REDO.APAP.CUST.SWIFT.DET table
* Ashokkumar
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Insert , Added call OfsGlobusManager

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CUST.SWIFT.DET

    FN.REDO.APAP.CUST.SWIFT.DET = 'F.REDO.APAP.CUST.SWIFT.DET'; F.REDO.APAP.CUST.SWIFT.DET = ''
    CALL OPF(FN.REDO.APAP.CUST.SWIFT.DET,F.REDO.APAP.CUST.SWIFT.DET)
    FN.SAVELST = '&SAVEDLISTS&'; F.SAVELST = ''
    CALL OPF(FN.SAVELST,F.SAVELST)

    READ R.SAVELST FROM F.SAVELST,'SWIFT.CUST' ELSE RETURN

    LOOP
        REMOVE SAVELST.ID FROM R.SAVELST SETTING SL.POSN
    WHILE SAVELST.ID:SL.POSN
        YSWIFT = ''; YDESCRIPT = ''; YCUSTOMR = ''
        YSWIFT = FIELD(SAVELST.ID,'|',1)
        YDESCRIPT = FIELD(SAVELST.ID,'|',2)
        YCUSTOMR = FIELD(SAVELST.ID,'|',3)

        ERR.REDO.APAP.CUST.SWIFT.DET = ''; R.REDO.APAP.CUST.SWIFT.DET = ''
        CALL F.READ(FN.REDO.APAP.CUST.SWIFT.DET,YSWIFT,R.REDO.APAP.CUST.SWIFT.DET,F.REDO.APAP.CUST.SWIFT.DET,ERR.REDO.APAP.CUST.SWIFT.DET)
        R.REDO.APAP.CUST.SWIFT.DET<REDO.CUSW.DESCRIPTION> = YDESCRIPT
        R.REDO.APAP.CUST.SWIFT.DET<REDO.CUSW.CUSTOMER.ID> = YCUSTOMR

        OFS.SOURCE.ID = 'OFS.LOAD'
        APPLICATION.NAME = 'REDO.APAP.CUST.SWIFT.DET'
        TRANS.FUNC.VAL = 'I'
        TRANS.OPER.VAL = 'PROCESS'
        APPLICATION.NAME.VERSION = 'REDO.APAP.CUST.SWIFT.DET,INP'
        NO.AUT = '0'
        OFS.MSG.ID = ''
        APPLICATION.ID = YSWIFT
        OFS.POST.MSG = ''; TEMP.REST = ''
        CALL LOAD.COMPANY(YCO.CODE)
        CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.REDO.APAP.CUST.SWIFT.DET,OFS.COLLRGT)
        CRT OFS.COLLRGT
        CALL OfsGlobusManager('OFS.LOAD',OFS.COLLRGT)		;*R22 Manual Conversion - Added call OfsGlobusManager
        CRT OFS.COLLRGT
        CALL JOURNAL.UPDATE('')
    REPEAT
    PRINT "Process Completed"
RETURN
END
