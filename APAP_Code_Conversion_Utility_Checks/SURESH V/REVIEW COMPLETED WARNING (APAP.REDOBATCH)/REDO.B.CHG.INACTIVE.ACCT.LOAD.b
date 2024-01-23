* @ValidationCode : MjoyNzU0Mjg3MjpDcDEyNTI6MTcwMzIyMDY4ODk2MTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2023 10:21:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHG.INACTIVE.ACCT.LOAD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHG.INACTIVE.ACCT.LOAD
*--------------------------------------------------------------------------------------------------------
*Description  : This is a load routine to opens all the necesseary tables & files
*
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 Mar 2011    Krishna Murthy T.S   ODR-2011-03-0142           Initial Creation
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND SM TO @SM AND F.READ TO CACHE.READ AND REMOVED F.FT.COMMISSION
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*21/12/2023         Suresh                R22 Manual Conversion    IDVAR Variable Changed
*--------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.CHARGE.PARAM
    $INSERT I_REDO.B.CHG.INACTIVE.ACCT.COMMON

    GOSUB OPENFILES
    GOSUB GET.LOC.POSNS
    GOSUB READ.CHARGE.PARAM
RETURN

*---------
OPENFILES:
*---------
*Opening the necesseary tables & initialising the variables

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    Y.AC.ERR = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE = ''
    R.FT.COMMISSION.TYPE = ''
    Y.FCT.ERR = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.REDO.CHARGE.PARAM = 'F.REDO.CHARGE.PARAM'
    F.REDO.CHARGE.PARAM = ''
    R.REDO.CHARGE.PARAM = ''
    Y.PARAM.ERR = ''
    CALL OPF(FN.REDO.CHARGE.PARAM,F.REDO.CHARGE.PARAM)
RETURN

*-------------
GET.LOC.POSNS:
*-------------
*Getting the Local reference field positions

    Y.APPLNS     = 'ACCOUNT'
    Y.LOC.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2'
    Y.LOC.POSNS  = ''
    CALL MULTI.GET.LOC.REF(Y.APPLNS,Y.LOC.FIELDS,Y.LOC.POSNS)
    Y.L.AC.STATUS.1.POS = Y.LOC.POSNS<1,1>
    Y.L.AC.STATUS.2.POS = Y.LOC.POSNS<1,2>
RETURN

*-----------------
READ.CHARGE.PARAM:
*-----------------
*Reading the Param table REDO.CHARGE.PARAM
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*   CALL CACHE.READ(FN.REDO.CHARGE.PARAM,'SYSTEM',R.REDO.CHARGE.PARAM,Y.PARAM.ERR)
    CALL CACHE.READ(FN.REDO.CHARGE.PARAM,IDVAR,R.REDO.CHARGE.PARAM,Y.PARAM.ERR) ;*R22 Manual Conversion
    IF R.REDO.CHARGE.PARAM THEN
        Y.CHG.ACCT     = R.REDO.CHARGE.PARAM<CHG.PARAM.ACCOUNT>
        Y.CHG.CATEGORY = R.REDO.CHARGE.PARAM<CHG.PARAM.CATEGORY>
        Y.CHG.AMT      = R.REDO.CHARGE.PARAM<CHG.PARAM.AMOUNT>
        Y.FTCT         = R.REDO.CHARGE.PARAM<CHG.PARAM.FT.COMM.TYPE>
        Y.AC.STAT.1    = R.REDO.CHARGE.PARAM<CHG.PARAM.AC.STATUS.1>
        Y.AC.STAT.2    = R.REDO.CHARGE.PARAM<CHG.PARAM.AC.STATUS.2>
        GOSUB READ.FT.COMM.TYPE
        Y.DUP.CHG.ACCT = Y.CHG.ACCT; Y.DUP.CHG.CATEGORY = Y.CHG.CATEGORY; Y.DUP.CHG.AMT = Y.CHG.AMT; Y.DUP.FTCT = Y.FTCT; Y.DUP.AC.STAT.1 = Y.AC.STAT.1; Y.DUP.AC.STAT.2 = Y.AC.STAT.2; Y.ADD.CHD.ACCT = Y.DUP.CHG.ACCT
        Y.ADD.CHD.ACCT = CHANGE(Y.ADD.CHD.ACCT,@SM,@VM)
    END
RETURN

*-----------------
READ.FT.COMM.TYPE:
*-----------------
*Reading the FT.COMMISSION.TYPE record

    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.FTCT, R.FT.COMMISSION.TYPE, Y.FCT.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.FT.COMMISSION
    Y.FTCT.CUR.LIST = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
    Y.FTCT.AMT.LIST = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT>
    Y.FTCT.CATEGORY = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
RETURN
END
