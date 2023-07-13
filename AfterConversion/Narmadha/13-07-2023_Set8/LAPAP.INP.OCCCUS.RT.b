* @ValidationCode : MjotOTg2ODA2NzQyOlVURi04OjE2ODkyNTI3MDY1MTA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:21:46
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
SUBROUTINE LAPAP.INP.OCCCUS.RT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 13-07-2023    Narmadha V             R22 Manual Conversion   No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER ;*R22 Auto Conversion - END

    Y.LOG.ID = 'A-':ID.NEW

*MSG<-1> = 'Inicio Auth Routine'
*CALL LAPAP.LOGGER('TESTLOG',Y.LOG.ID,MSG)
    GOSUB DO.INITIALIZE
    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
        GOSUB DO.POST.OCC

        CALL System.setVariable("CURRENT.VAR.OCC.CUS","true")
    END
RETURN

DO.INITIALIZE:
    APPL.NAME.ARR = "REDO.ID.CARD.CHECK"
    FLD.NAME.ARR = "L.ADDRESS" : @VM : "L.TELEPHONE" : @VM : "L.ADI.INFO" : @VM : "L.NACIONALITY" : @VM : "L.BIRTH.DATE"
    FLD.NAME.ARR:= @VM : "L.OCC.GENDER" : @VM : "L.OCC.D.ADDRESS"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    Y.L.ADDRESS.POS = FLD.POS.ARR<1,1>
    Y.L.TELEPHONE.POS = FLD.POS.ARR<1,2>
    Y.L.ADI.INFO.POS = FLD.POS.ARR<1,3>
    Y.L.NACIONALITY.POS = FLD.POS.ARR<1,4>
    Y.L.BIRTH.DATE.POS = FLD.POS.ARR<1,5>
    Y.L.OCC.GENDER.POS = FLD.POS.ARR<1,6>
    Y.L.OCC.D.ADDRESS.POS = FLD.POS.ARR<1,7>


RETURN

DO.POST.OCC:
    Y.TRANS.ID = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    Y.APP.NAME = "ST.LAPAP.OCC.CUSTOMER"
    Y.VER.NAME = Y.APP.NAME :",RAD"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.OCC = ""

    R.OCC<ST.L.OCC.NAME> = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME)
    R.OCC<ST.L.OCC.DOCUMENT.TYPE> = R.NEW(REDO.CUS.PRF.IDENTITY.TYPE)
    R.OCC<ST.L.OCC.ADDRESS> = R.NEW(10)<1,Y.L.ADDRESS.POS>
    R.OCC<ST.L.OCC.TEL.NUMER> = R.NEW(10)<1,Y.L.TELEPHONE.POS>
    R.OCC<ST.L.OCC.ADI.INFO> = R.NEW(10)<1,Y.L.ADI.INFO.POS>
    R.OCC<ST.L.OCC.COUNTRY> = R.NEW(10)<1,Y.L.NACIONALITY.POS>
    R.OCC<ST.L.OCC.BIRTH.DATE> = R.NEW(10)<1,Y.L.BIRTH.DATE.POS>
    R.OCC<ST.L.OCC.IDENTIFICATION> = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    R.OCC<ST.L.OCC.GENDER> = R.NEW(10)<1,Y.L.OCC.GENDER.POS>
    R.OCC<ST.L.OCC.LOCAL.REF,1,1> = R.NEW(10)<1,Y.L.OCC.D.ADDRESS.POS>



    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.OCC,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"GENOFS",'')
*MSG = ''
*MSG<-1> = 'OFS POSTED'
*MSG<-1> = FINAL.OFS
*CALL LAPAP.LOGGER('TESTLOG','A-':ID.NEW,MSG)
RETURN
END
