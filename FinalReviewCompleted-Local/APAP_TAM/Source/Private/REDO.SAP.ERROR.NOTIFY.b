* @ValidationCode : Mjo4OTA2OTA0NjE6Q3AxMjUyOjE2ODQ4NDIxMzA2NjI6SVRTUzotMTotMTotOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SAP.ERROR.NOTIFY(Y.OFS.MSG)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* To log and send mail when error occurs in T24-SAP communication and transaction through web service
*------------------------------------------------------------------------------------------------------
*APPLICATION
* attached as OUT.RTN in OFS.SOURCE GCS
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : Y.OFS.MSG
* OUT    : Y.OFS.MSG
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.SAP.ERROR.NOTIFY
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*23.08.2010      Janani     ODR-2010-08-0102    INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION        CALL Rtn format modified
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING APAP.REDOCHNLS
   
    GOSUB PROCESS
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    Y.ERR = FIELD(Y.OFS.MSG,'/',3)
    IF Y.ERR EQ '-1' THEN
        ERR.DESP = FIELD(Y.OFS.MSG,',',2)

        CHANGE "=" TO " " IN ERR.DESP

        INT.CODE = 'SAP001'
        INT.TYPE = 'ONLINE'
        BAT.NO = ''
        BAT.TOT = ''
        INFO.OR = 'SAP'
        INFO.DE = 'T24'
        ID.PROC = FIELD(Y.OFS.MSG,'/',1)
        MON.TP = '04'
        DESC = ERR.DESP
        REC.CON = 'REJECT: ':DESC
        EX.USER = ''
        EX.PC = ''
        CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
    END
RETURN
*------------------------------------------------------------
END
