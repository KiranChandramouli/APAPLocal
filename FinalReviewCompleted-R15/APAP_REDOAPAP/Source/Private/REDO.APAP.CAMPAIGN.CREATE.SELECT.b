* @ValidationCode : MjotMjIyOTgxNTA6Q3AxMjUyOjE2OTAyNjQyNTgyOTQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:20:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CAMPAIGN.CREATE.SELECT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.CREATE.SELECT
* ODR NUMBER    : ODR-2010-08-0228
*--------------------------------------------------------------------------------
* Description : This is a .select routine to select the required records
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



* ----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CR.OPPORTUNITY
    $INSERT I_REDO.APAP.CAMPAIGN.CREATE.COMMON
    $USING APAP.REDOCHNLS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*
INIT:
*-----
    SEL.CMD = ''
    SEL.LIST = ''
    NO.OF.RECS = ''
    SEL.ERR = ''
RETURN
*
PROCESS:
*-------

    SEL.CMD = "SELECT ":FN.CR.OPP:" WITH OPPOR.DEF.ID EQ ":Y.DAT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    IF SEL.LIST EQ '' THEN
        INT.CODE = 'CTI001'
        INT.TYPE = 'BATCH'
        BAT.NO   = ''
        BAT.TOT  = ''
        INFO.OR  = ''
        INFO.DE  = ''
        ID.PROC  = Y.DAT
        MON.TP   = '03'
        DESC     = 'No Records found for Campaign ':Y.DAT
        REC.CON  = ''
        EX.USER  = ''
        EX.PC    = ''
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
    END
    CALL BATCH.BUILD.LIST("",SEL.LIST)
RETURN
END
