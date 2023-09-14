* @ValidationCode : Mjo3MDI0MDQ3NzpDcDEyNTI6MTY4MTI4MzkzNzA1MDpJVFNTOi0xOi0xOjM4NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 384
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AZ.AC.DEL.CLOSE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.AC.AUT.FD.PREC
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a AUTHORIZATION ROUTINE attached to the version AZ.ACCOUNT,FD.PRECLOSE
*                    It is to discount the penalty amount from Net amount of the Deposit which is preclosed
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  20/06/2010       REKHA S            ODR-2009-10-0336 N.18      Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           IF STATEMENT ADDED
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.USER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_System
    $INSERT I_F.REDO.CLOSE.ACCT

    GOSUB INIT

    GOSUB WROK.FILE.UPD
RETURN

*--------------------------------------------------------------------
WROK.FILE.UPD:
*--------------------------------------------------------------------
    FN.REDO.CLOSE.ACCT = 'F.REDO.CLOSE.ACCT'
    F.REDO.CLOSE.ACCT = ''
    CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)
    Y.ID = System.getVariable("CURRENT.DATA")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* AUTO CODE CONVERSION START
        Y.ID = ""
    END ;* AUTO CODE CONVERSION END
    CALL F.DELETE(FN.REDO.CLOSE.ACCT,Y.ID)

RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'

    R.OFS=''

RETURN

END
