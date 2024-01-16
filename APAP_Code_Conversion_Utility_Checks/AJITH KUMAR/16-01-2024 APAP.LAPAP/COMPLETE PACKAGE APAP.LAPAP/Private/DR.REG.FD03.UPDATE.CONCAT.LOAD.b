* @ValidationCode : MjotMTE5Nzc5NzM0MDpDcDEyNTI6MTcwMjk4ODM0MTg3NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:01
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
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.FD03.UPDATE.CONCAT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.FD03.TXN.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the tranactions made over 1000 by individual Customer daily.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 02-Aug-2014  Ashokkumar.V.P      PACS00316981 - Updated new parameter fields.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  REGREP.BP,LAPAP.BP, T24.BP is removed ,$INCLUDE to$INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*15-12-2023       Santosh C                   MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES

    $INSERT I_DR.REG.FD03.UPDATE.CONCAT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.DR.REG.FD03.PARAM ;*R22 AUTO CODE CONVERSION
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check
    
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
RETURN
*----------------------------------------------------------
OPEN.FILES:
***********

    FN.STMT.ENTRY = 'F.STMT.ENTRY'  ; F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY, F.STMT.ENTRY)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'  ; F.FT.HIS = ''
    CALL OPF(FN.FT.HIS, F.FT.HIS)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.ACCT.ENT.LWORK.DAY = 'F.ACCT.ENT.LWORK.DAY'  ; F.ACCT.ENT.LWORK.DAY = ""
    CALL OPF(FN.ACCT.ENT.LWORK.DAY, F.ACCT.ENT.LWORK.DAY)

    FN.DR.REG.FD03.PARAM = 'F.DR.REG.FD03.PARAM'   ; F.DR.REG.FD03.PARAM = ''
    CALL OPF(FN.DR.REG.FD03.PARAM, F.DR.REG.FD03.PARAM)

    FN.DR.REG.FD03.CONCAT = 'F.DR.REG.FD03.CONCAT'; F.DR.REG.FD03.CONCAT = ''
    CALL OPF(FN.DR.REG.FD03.CONCAT,F.DR.REG.FD03.CONCAT)

RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********
    R.DR.REG.FD03.PARAM = ''; DR.REG.FD03.PARAM.ERR = ''; YTHRESHOLD.FAMT = ''
    FTTC.PAY.TYPES = ''; L.FTTC.PAY.TYPE.POS = ''
    Y.SYS.ID = "SYSTEM"  ;*R22 Manual Code Conversion_Utility Check
    CALL CACHE.READ(FN.DR.REG.FD03.PARAM, Y.SYS.ID, R.DR.REG.FD03.PARAM, DR.REG.FD03.PARAM.ERR)
    FTTC.PAY.TYPES = R.DR.REG.FD03.PARAM<DR.FD03.PARAM.FTTC.PAY.TYPES>
    CHANGE @VM TO @FM IN FTTC.PAY.TYPES
    YTHRESHOLD.FAMT = R.DR.REG.FD03.PARAM<DR.FD03.PARAM.THRESHOLD.FAMT>
    LAST.WRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
*   CALL GET.LOC.REF('FT.TXN.TYPE.CONDITION','L.FTTC.PAY.TYPE',L.FTTC.PAY.TYPE.POS)
    EB.LocalReferences.GetLocRef('FT.TXN.TYPE.CONDITION','L.FTTC.PAY.TYPE',L.FTTC.PAY.TYPE.POS) ;*R22 Manual Code Conversion_Utility Check
*
RETURN
*----------------------------------------------------------------
END
