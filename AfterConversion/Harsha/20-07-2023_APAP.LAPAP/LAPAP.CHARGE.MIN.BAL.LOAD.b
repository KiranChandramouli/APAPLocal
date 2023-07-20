* @ValidationCode : MjoxMjMxOTk3MDI0OkNwMTI1MjoxNjg5MjMwNzgxNDk3OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 12:16:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CHARGE.MIN.BAL.LOAD

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.CUSTOMER.ACCOUNT
    $INSERT  I_TSA.COMMON
    $INSERT  I_AA.LOCAL.COMMON
    $INSERT  I_F.COMPANY
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INCLUDE I_F.LAPAP.CHARGE.BAL.MIN.PARAM
    $INSERT  I_LAPAP.CHARGE.MIN.BAL.COMMON

    GOSUB INIT

RETURN
*****
INIT:
*****
***************PARAMETRIZACION INICIAL****************
    Y.STATUS.COM = 'AC':@FM:'EM':@FM:'PG';
    Y.FECHA = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.YEAR.ACT = Y.FECHA[1,4]
    Y.MES.ACT = Y.FECHA[5,2]
    Y.MES.ACT = Y.MES.ACT * 1;
******************************************************
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ST.LAPAP.CHARGE.BAL.MIN.PARAM = 'F.ST.LAPAP.CHARGE.BAL.MIN.PARAM'
    F.ST.LAPAP.CHARGE.BAL.MIN.PARAM = ''
    CALL OPF(FN.ST.LAPAP.CHARGE.BAL.MIN.PARAM,F.ST.LAPAP.CHARGE.BAL.MIN.PARAM)
RETURN
END
