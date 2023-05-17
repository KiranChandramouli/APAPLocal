* @ValidationCode : MjotMTc3NzMzNTcwODpDcDEyNTI6MTY4MjMzMTU2NTI2MjpJVFNTOi0xOi0xOjc2NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 764
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.ACCT.PROVINCE.LOAD
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .LOAD Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
*                       Ashokkumar.V.P                  17/02/2016           Changes to avoid the customer data issue

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP, SM TO @SM
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------
    $INSERT I_COMMON                     ;** R22 Auto conversion
    $INSERT I_EQUATE                     ;** R22 Auto conversion
    $INSERT I_F.CUSTOMER                 ;** R22 Auto conversion
    $INSERT I_F.ACCOUNT                  ;** R22 Auto conversion
    $INSERT I_TSA.COMMON                 ;** R22 Auto conversion
    $INSERT I_BATCH.FILES                ;** R22 Auto conversion
    $INSERT I_REDO.B.ACCT.PROVINCE.COMMON           ;** R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM                ;** R22 Auto conversion

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

*-------------------------------------------------------------------------------
OPEN.PARA:
*---------

    FN.RE.CRF.MBGL = 'F.RE.CRF.MBGL'
    F.RE.CRF.MBGL = ''
    CALL OPF(FN.RE.CRF.MBGL,F.RE.CRF.MBGL)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.H = 'F.CUSTOMER$HIS'
    F.CUSTOMER.H = ''
    CALL OPF(FN.CUSTOMER.H,F.CUSTOMER.H)

    FN.ACCOUNT.H = 'F.ACCOUNT$HIS'
    F.ACCOUNT.H = ''
    CALL OPF(FN.ACCOUNT.H,F.ACCOUNT.H)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.COMPANY = 'F.COMPANY'; FV.COMPANY = ''
    CALL OPF(FN.COMPANY,FV.COMPANY)

    FN.DR.REG.PROV.WORKFILE = 'F.DR.REG.PROV.WORKFILE'; F.DR.REG.PROV.WORKFILE = ''
    CALL OPF(FN.DR.REG.PROV.WORKFILE, F.DR.REG.PROV.WORKFILE)
RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
    GOSUB GET.CO.CODES
    GOSUB GET.MULTI.LOCAL.REF
    PROCESS.POST.RTN = ''
RETURN
*-------------------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = "REDO.PROV"
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    END
RETURN
*---------------------------------------------------------------------------------
GET.CO.CODES:
*------------
    LOCATE 'REGION' IN FIELD.NAME<1,1> SETTING REG.FOUND.POS THEN
        Y.REG.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,REG.FOUND.POS>
        Y.REG.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,REG.FOUND.POS>
    END

    LOCATE 'REGION1' IN FIELD.NAME<1,1> SETTING R1.FOUND.POS THEN
        Y.R1.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,R1.FOUND.POS>
        Y.R1.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,R1.FOUND.POS>
    END

    LOCATE 'REGION2' IN FIELD.NAME<1,1> SETTING R2.FOUND.POS THEN
        Y.R2.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,R2.FOUND.POS>
        Y.R2.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,R2.FOUND.POS>
    END

    LOCATE 'REGION3' IN FIELD.NAME<1,1> SETTING R3.FOUND.POS THEN
        Y.R3.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,R3.FOUND.POS>
        Y.R3.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,R3.FOUND.POS>
    END

    LOCATE 'COLUMN' IN FIELD.NAME<1,1> SETTING COL.POS THEN
        Y.COLUMN.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,COL.POS>
        CHANGE @SM TO @FM IN Y.COLUMN.ID
    END
RETURN
*------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.APPLICATION = 'CUSTOMER':@FM:'COMPANY'
    Y.FIELDS = 'L.LOCALIDAD':@FM:'L.LOCALIDAD'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    L.LOCALIDAD.POS = Y.POS<1,1>
    LCOMP.LOCALIDAD.POS = Y.POS<2,1>
RETURN
END
