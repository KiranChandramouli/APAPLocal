* @ValidationCode : Mjo3NjE3MzY0MjI6Q3AxMjUyOjE3MDQ0NDU4OTYwMTI6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:41:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
*Modification history
*Date                Who               Reference                  Description
*18-04-2023      conversion tool     R22 Auto code conversion     No changes
*18-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE REDO.V.VAL.ACCOUNT.INITIAL
*------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry NOFILE.REDO.INS.PAYMENTS
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : REDO.V.VAL.ACCOUNT.INITIAL
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
* 24.06.2010 HARISH.Y ODR-2009-10-0340 INITIAL CREATION
* -----------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $USING EB.LocalReferences

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------
INIT:
*---------
*    CALL GET.LOC.REF('AA.ARR.ACCOUNT',POLICY.STATUS,POL.STAT.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',POLICY.STATUS,POL.STAT.POS);* R22 UTILITY AUTO CONVERSION
RETURN

*----------
PROCESS:
*----------

    R.NEW(AA.AC.LOCAL.REF)<1,POL.STAT.POS> = 'CURRENT'
RETURN
END
