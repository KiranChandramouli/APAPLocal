* @ValidationCode : MjotMTM1ODg5NTc5MjpDcDEyNTI6MTY4MDY3MTc1Nzc3MjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHK.DEPOSIT.AMT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine will get the TELLER.DEFAULT id and update the same to OUR.REFERENCE field.
*--------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
*  12.12.2011      S.Sudharsanan     PACS00146871        Initial Creation
*  05.01.2011      S.Sudharsanan     PACS00167691        Modify the code
** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.TRANS.CODE.PARAM
    $INSERT I_F.TELLER.DEFAULT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT = ''
    CALL OPF(FN.TELLER.DEFAULT,F.TELLER.DEFAULT)
RETURN
*-------
PROCESS:
*-------
    Y.VALUE= R.NEW(TT.TE.ACCOUNT.2)
*PACS00167691 - S
*VAR.OUR.REF = Y.VALUE:'*':TODAY
    VAR.OUR.REF = Y.VALUE
*PACS00167691 - E

    SEL.CMD = "SSELECT ":FN.TELLER.DEFAULT:" WITH @ID LIKE ":VAR.OUR.REF:"... AND TRANSACTION.REF EQ ''"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ER.REC)
    VAR.OUR.REF.ID = SEL.LIST<1>

    R.NEW(TT.TE.OUR.REFERENCE) = VAR.OUR.REF.ID

RETURN

END
