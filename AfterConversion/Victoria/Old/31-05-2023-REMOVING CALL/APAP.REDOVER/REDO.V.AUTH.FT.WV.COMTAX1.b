* @ValidationCode : MjoxMzg4MDE4NzYzOkNwMTI1MjoxNjgyNDEyMzM5NTA5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUTH.FT.WV.COMTAX1
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED AT    : 13-08-2018
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in FT versions
*                   Accounting of each COMM/TAX value in a separate debit
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO                 REFERENCE                      DESCRIPTION
*10-04-2023       Conversion Tool      R22 Auto Code conversion       VM TO @VM
*10-04-2023        Samaran T            R22 Manual Code conversion    No Changes

*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.BENEFICIARY

    PROCESS.GOHEAD='1'
*   CRT  R.NEW(FT.RECORD.STATUS)
    IF V$FUNCTION MATCHES "I"  OR V$FUNCTION EQ "A" AND R.NEW(FT.RECORD.STATUS) MATCHES "INAU":@VM:"INAO" ELSE
        PROCESS.GOHEAD = ""
    END

    IF RUNNING.UNDER.BATCH THEN
        PROCESS.GOHEAD = '1'
    END

    IF PROCESS.GOHEAD THEN
        Y.STMT.NO       = R.NEW(FT.STMT.NOS)
        CALL EB.ACCOUNTING("AC","AUT",'','')
        Y.STMT.NO.NEW = R.NEW(FT.STMT.NOS)

        R.NEW(FT.STMT.NOS)       = Y.STMT.NO
        R.NEW(FT.STMT.NOS)<1,-1> = ID.COMPANY
        R.NEW(FT.STMT.NOS)<1,-1> = Y.STMT.NO.NEW

    END
RETURN
END
