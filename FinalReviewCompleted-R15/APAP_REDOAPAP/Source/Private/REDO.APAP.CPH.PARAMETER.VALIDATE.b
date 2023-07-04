* @ValidationCode : MjotMTI2NTI2NjE3MjpDcDEyNTI6MTY4NDgzNjAzNjYyNDpJVFNTOi0xOi0xOi0yMzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -23
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CPH.PARAMETER.VALIDATE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CPH.PARAMETER.VALIDATE
*------------------------------------------------------------------------------

*Description  : REDO.APAP.CPH.PARAMETER.VALIDATE is a subroutine to validate
*               CPH Category and MG Category in REDO.APAP.CPH.PARAMETER
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.APAP.CPH.PARAMETER

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11-08-2010       JEEVA T            ODR-2009-10-0346         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , ++ to +=
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
*--------------------------------------------------------------------------------
**********
MAIN.PARA:
*********
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------
**************
PROCESS.PARA:
**************
    Y.CPH.CATS= R.NEW(CPH.PARAM.CPH.CATEGORY)
    Y.MG.CATS=R.NEW(CPH.PARAM.MG.CATEGORY)
    Y.CAT.COUNT=DCOUNT(Y.CPH.CATS,@VM)
    AF=CPH.PARAM.CPH.CATEGORY
    Y.CATS=Y.CPH.CATS
    GOSUB CHECK.CATEGORY
    Y.CAT.COUNT=DCOUNT(Y.MG.CATS,@VM)
    AF=CPH.PARAM.MG.CATEGORY
    Y.CATS=Y.MG.CATS
    GOSUB CHECK.CATEGORY
RETURN
*--------------------------------------------------------------------------------
***************
CHECK.CATEGORY:
***************
    Y.COUNT =1
    LOOP
    WHILE Y.COUNT LE Y.CAT.COUNT
        Y.CAT.ID = Y.CATS<1,Y.COUNT>
        IF Y.CAT.ID LT '1000' OR Y.CAT.ID GT '9999' THEN
            AV =Y.COUNT
            ETEXT ='EB-NOT.VALID.CATEGORY'
            CALL STORE.END.ERROR
        END
        Y.COUNT += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN
*--------------------------------------------------------------------------------
END
