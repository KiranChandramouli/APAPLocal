* @ValidationCode : MjoxOTE2MjUyNDgyOlVURi04OjE3MDUzODA4NjI0NzY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jan 2024 10:24:22
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.SAP.GL.EXT.REP.REC(GIT.ID.MAPPED,GIT.MAPPED.REC,GIT.MISN,GIT.R.PROCESS,GIT.ERR)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.EXT.REP.REC
*--------------------------------------------------------------------------------------------------------
*Description  :This routine is used to remove the additional delimiter added in main routine
*Linked With  : GIT.INTERFACE.OUT id SAP.NORMAL.EXTRACT,SAP.REVAL.EXTRACT,SAP.DETAIL.REPORT
*In Parameter : GIT.ID.MAPPED
*Out Parameter: GIT.MAPPED.REC,GIT.MISN,GIT.R.PROCESS,GIT.ERR
*
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 OCT 2010    Shiva Prasad Y        ODR-2009-12-0294 C.12         Initial Creation
* 25 JUN 2010    Prabhu N              PACS00032519                  Encryption added
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*12-01-2024    Harish Vikaram C    Manual R22 Conversion   F.READ to CACHE.READ
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GIT.COMMON
    $INSERT I_F.GIT.INTERFACE.OUT
    $INSERT JBC.h
    $INSERT I_F.REDO.INTERFACE.PARAM
*--------------------------------------------------------------------------------------------------------
*********
MAIN.PARA:
*********


    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*********
OPEN.PARA:
*********
    FN.GIT.INTERFACE.OUT = 'F.GIT.INTERFACE.OUT'
    F.GIT.INTERFACE.OUT = ''
    CALL OPF(FN.GIT.INTERFACE.OUT,F.GIT.INTERFACE.OUT)

    NEW.GIT.MAPPED.REC = ''
RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    GOSUB GET.REC.FLD.DELIM
    GOSUB CHANGE.DELIM

    GIT.MAPPED.REC = NEW.GIT.MAPPED.REC


RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.REC.FLD.DELIM:
*****************
    GIT.INTERFACE.OUT.ID = GIT.COM.OUT.INT.ID
    GOSUB READ.GIT.INTERFACE.OUT

    IF NOT(R.GIT.INTERFACE.OUT) THEN
        RETURN
    END

    Y.REC.DELIM   = R.GIT.INTERFACE.OUT<GIT.INT.OUT.RECORD.DELIM>
    IF NOT(Y.REC.DELIM) THEN
        Y.REC.DELIM = 'FM'
    END

    Y.FIELD.DELIM = R.GIT.INTERFACE.OUT<GIT.INT.OUT.FIELD.DELIM>
    IF NOT(Y.FIELD.DELIM) THEN
        Y.FIELD.DELIM = ','
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************
CHANGE.DELIM:
************
    CHANGE '#' TO @FM IN GIT.MAPPED.REC ;*R22 AUTO CONVERSION
    DEL GIT.MAPPED.REC<1>

    LOOP
        REMOVE Y.RECORD.LINE FROM GIT.MAPPED.REC SETTING Y.REC.POS
    WHILE Y.RECORD.LINE : Y.REC.POS



        CHANGE '*' TO Y.FIELD.DELIM IN Y.RECORD.LINE
        R.RETURN.MESSAGE=Y.RECORD.LINE

*       GOSUB INITIALIZE.ENCRYPT
*       GOSUB OPEN.FILES.ENCRYPT
*       GOSUB PROCESS.ENCRYPT
        NEW.GIT.MAPPED.REC<-1> = Y.RECORD.LINE
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
INITIALIZE.ENCRYPT:
*************************
    Y.ERR = ''
    Y.PARAM.ID = "DES333"
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
    R.REDO.INTERFACE.PARAM = ""
    GOAHEAD = ''
RETURN
*************************
OPEN.FILES.ENCRYPT:
*************************
*CALL OPF(FN.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM)
*CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.PARAM.ID, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, Y.PARAM.ID, R.REDO.INTERFACE.PARAM,Y.ERR) ;*Manual R22 Conversion
    IF NOT(R.REDO.INTERFACE.PARAM) THEN
        RETURN
    END
    GOAHEAD = 'TRUE'
    yEncripKey = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIP.KEY>
    yLine = R.RETURN.MESSAGE

RETURN
*************************
PROCESS.ENCRYPT:
*************************
*PACS00071961-S
    IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIPTATION> EQ 'SI' THEN
        yLine = ENCRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_3DES_BASE64)
*PACS00071961-E
    END ELSE
        yLine = R.RETURN.MESSAGE
    END

    Y.RECORD.LINE=yLine
RETURN
**********************
READ.GIT.INTERFACE.OUT:
**********************
    R.GIT.INTERFACE.OUT  = ''
    GIT.INTERFACE.OUT.ER = ''
    CALL F.READ(FN.GIT.INTERFACE.OUT,GIT.INTERFACE.OUT.ID,R.GIT.INTERFACE.OUT,F.GIT.INTERFACE.OUT,GIT.INTERFACE.OUT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------

END       ;* End of Program
