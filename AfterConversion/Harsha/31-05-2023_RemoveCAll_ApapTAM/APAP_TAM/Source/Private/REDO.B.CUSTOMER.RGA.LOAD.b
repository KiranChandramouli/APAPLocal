* @ValidationCode : MjotMTEwNzg1NTQzNTpDcDEyNTI6MTY4NDQ5MTAyODkzMzpJVFNTOi0xOi0xOjI2ODoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 268
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.CUSTOMER.RGA.LOAD
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .LOAD Subroutine
*
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*   Date       Author              Modification Description
*
* 05/02/2015  Ashokkumar.V.P        PACS00368383 - New mapping changes

** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_REDO.B.CUSTOMER.RGA.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
*

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
*
RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.RIEN15.WORKFILE = 'F.DR.REG.RIEN15.WORKFILE'
    F.DR.REG.RIEN15.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN15.WORKFILE,F.DR.REG.RIEN15.WORKFILE)
    Y.FLAG = 1
RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
    GOSUB GET.MULTI.LOCAL.REF
    PROCESS.POST.RTN = ''
RETURN
*-------------------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = 'REDO.RN15'
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
RETURN

GET.MULTI.LOCAL.REF:
*-------------------
*
    Y.POS = ''
    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT':@VM:'L.CU.TIPO.CL':@VM:'L.CU.GRP.RIESGO'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    L.CU.CIDENT.POS = Y.POS<1,1>
    L.CU.RNC.POS = Y.POS<1,2>
    L.CU.FOREIGN.POS = Y.POS<1,3>
    L.CU.TIPO.CL.POS = Y.POS<1,4>
    L.CU.GRP.RIESGO.POS = Y.POS<1,5>
RETURN
*----------------------------------------------------------------------
END
