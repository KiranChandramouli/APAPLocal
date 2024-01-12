* @ValidationCode : MjotNTMzOTk2OTU0OkNwMTI1MjoxNjgyNDEyMzYxMzE2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.FT.ADJ.NOSTRO
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.FT.ADJ.NOSTRO
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is the validation routine to get nostro customer
*initilise profit centre customer to ''
* read account.class nostro and locate account category in the list of category
*provided in nostro record. if account category is nostro then default nostro account
*customer in the profit centre customer field. apply same procedure for both credit and debit
*account
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 1-JUL-2013       Prabhu.N       ODR-2010-08-0031        Initial Creation
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     F.READ TO CACHE.READ
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------

    FN.ACCOUNT.CLASS='F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS =''
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

*    CALL CACHE.READ(FN.ACCOUNT.CLASS, 'NOSTRO', R.ACCOUNT.CLASS, ERR) ;*R22 Auto code conversion
IDVAR.1 = 'NOSTRO' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.ACCOUNT.CLASS, IDVAR.1, R.ACCOUNT.CLASS, ERR) ;*R22 Auto code conversion;* R22 UTILITY AUTO CONVERSION
    Y.CATEGORY.LIST=R.ACCOUNT.CLASS<AC.CLS.CATEGORY>

    R.NEW(FT.PROFIT.CENTRE.CUST)=''
    Y.ACCT=R.NEW(FT.DEBIT.ACCT.NO)
    Y.DEF.PROFIT.CUST=''
    GOSUB DEF.PROFIT.CUSTOMER
    Y.ACCT=COMI
    GOSUB DEF.PROFIT.CUSTOMER
    R.NEW(FT.PROFIT.CENTRE.CUST)=Y.DEF.PROFIT.CUST
RETURN

*-------------------
DEF.PROFIT.CUSTOMER:
*-------------------
    CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ERR)
    Y.CATEGORY     =R.ACCOUNT<AC.CATEGORY>
    LOCATE Y.CATEGORY IN Y.CATEGORY.LIST<1,1> SETTING Y.TRUE THEN
        Y.DEF.PROFIT.CUST=R.ACCOUNT<AC.CUSTOMER>
    END

RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
