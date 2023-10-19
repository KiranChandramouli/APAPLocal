* @ValidationCode : MjoxOTM2NDEyNTUyOkNwMTI1MjoxNjg1NTI2NjE5NjQyOnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 15:20:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL ROUTINE ADDED
SUBROUTINE REDO.COL.FF.EXTRACT.LOAD
**-----------------------------------------------------------------------------
* REDO.COL.FF.EXTRACT.LOAD routine to load the variables
*
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* performance routine creation for collector issue
*
* -------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.COL.FF.EXTRACT.PRE.COMMON
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $USING APAP.TAM
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB PROCESS
*CALL APAP.TAM.REDO.CALL.COL.FF.EXTRACT.LOAD
    APAP.TAM.redoCallColFfExtractLoad();* R22 Manual conversion - CALL method format changed

RETURN

*-----------
INITIALISE:
*-----------

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT =''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN

*----------
PROCESS:
*----------
    Y.RID.ID = "COL001"
    R.REDO.INTERFACE.PARAM = ''
    CALL CACHE.READ('F.REDO.INTERFACE.PARAM', Y.RID.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        TEXT = "ERROR READING REDO.INTERFACE.PARAM - " : Y.ERR
        CALL FATAL.ERROR("REDO.COL.EXTRACT.PRE.LOAD")
    END

    Y.OUT.FILE.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
    GOSUB CHECK.FILE.PATH
    Y.OUT.FILE.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.REJECT.PATH>
    GOSUB CHECK.FILE.PATH

    GOSUB GET.AA.CRITERIA

    Y.TABLE=""
    C.TABLES=""
    C.TABLES<-1>='tmpclientes'
    C.TABLES<-1>='tmptelefonoscliente'
    C.TABLES<-1>='tmpdireccionesclientebase'
    C.TABLES<-1>='tmpmovimientos'
    C.TABLES<-1>='tmpcredito'
RETURN
*-----------------------------------------------------------------------------
GET.AA.CRITERIA:
*-----------------------------------------------------------------------------
* Criteria Selection
    fieldParamType  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    paramType = 'AA.PRD.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    C.AA.PRODUCT.GROUP = paramValue
    IF C.AA.PRODUCT.GROUP EQ '' THEN
        CALL OCOMO("Parameter AA.PRD.SELECTION was not def... using default")
        C.AA.PRODUCT.GROUP = "COMERCIAL,HIPOTECARIO,CONSUMO"
    END
    paramType = 'AA.STA.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    C.AA.STATUS = paramValue
    IF C.AA.STATUS EQ '' THEN
        CALL OCOMO("Parameter AA.STA.SELECTION was not def... using default")
        C.AA.STATUS = "CURRENT,AUTH,EXPIRED"
    END

    C.AA.PRODUCT.GROUP = CHANGE(C.AA.PRODUCT.GROUP,",", @VM)
    C.AA.STATUS = CHANGE(C.AA.STATUS,",", @VM)
*need to change
    C.AA.PRD.SELECTION =C.AA.PRODUCT.GROUP
    C.AA.STA.SELECTION =C.AA.STATUS


RETURN

*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

    valueNo = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
RETURN
*-----------------------------------------------------------------------------
CHECK.FILE.PATH:
*-----------------------------------------------------------------------------
    OPEN Y.OUT.FILE.PATH TO F.EXTRACT.OUT.FILE.PATH ELSE

        MON.TP = "04"
        REC.CON = 'CANNOT OPEN FILE PATH':Y.OUT.FILE.PATH
        DESC = "CANNOT OPEN FILE PATH"
        INT.CODE = 'COL001'
        INT.TYPE = 'BATCH'
        BAT.NO = ''
        BAT.TOT = ''
        INFO.OR = ''
        INFO.DE = ''
        ID.PROC = ''
        EX.USER = ''
        EX.PC = ''
*CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);* R22 Manual conversion - CALL method format changed
    END
RETURN
END
