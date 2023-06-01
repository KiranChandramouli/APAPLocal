* @ValidationCode : MjotMjA0Njc1NDgyNTpDcDEyNTI6MTY4NDgzNjA1MTk2NDpJVFNTOi0xOi0xOjYwOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 60
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.REINV.VAL.L.MG.ACT.NO
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.REINV.VAL.L.MG.ACT.NO
*------------------------------------------------------------------------------
*Description  : REDO.APAP.REINV.VAL.L.MG.ACT.NO is a validation routine for the
*               version REDO.H.AZ.REINV.DEPOSIT, CPH which restricts the user
*               from entering values into field mortgage account no if the
*               category code is not of CPH. Also alerts the user to link loan
*               if CPH category is used and no loan is linked
*Linked With  : REDO.H.AZ.REINV.DEPOSIT,CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : I_F.REDO.APAP.CPH.PARAMETER,I_F. REDO.H.AZ.REINV.DEPOSIT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 03-08-2010       JEEVA T             ODR-2009-10-0346        Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.H.AZ.REINV.DEPOSIT
*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'
    F.REDO.APAP.CPH.PARAMETER= ''
    CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)
RETURN
*-------------------------------------------------------------------------
**********
PROCESS.PARA:
**********

    Y.MG.ACT.NOS=COMI
    GOSUB READ.CPH.PARAMETER
    Y.DEP.CAT =R.NEW(REDO.AZ.REINV.PRODUCT.CODE)
    GOSUB VAL.CATEGORY.AND.LOAN
RETURN
*--------------------------------------------------------------------------------
**********
READ.CPH.PARAMETER:
**********
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,'SYSTEM',R.REDO.APAP.CPH.PARAMETER,REDO.APAP.CPH.PARAMETER.ERR)
    Y.CPH.CATS=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.CPH.CATEGORY>
RETURN
*---------------------------------------------------------------------------------------------------------------------------------
**********
VAL.CATEGORY.AND.LOAN:
**********

    CHANGE @VM TO @FM IN Y.CPH.CATS
    LOCATE Y.DEP.CAT IN Y.CPH.CATS SETTING Y.DEP.CAT.POS THEN
        IF  NOT(Y.MG.ACT.NOS) THEN
            ETEXT = 'EB-REDO.NO.LOAN.LINKED'
            CALL STORE.END.ERROR
            RETURN
        END
    END ELSE
        IF Y.MG.ACT.NOS THEN
            ETEXT = 'EB-REDO.NOT.CPH.CAT'
            CALL STORE.END.ERROR
            RETURN
        END
    END
*CALL APAP.REDOAPAP.REDO.APAP.REINV.VAL.FHA.DETS ;*R22 MANUAL CODE CONVERSION
    CALL APAP.REDOAPAP.redoApapReinvValFhaDets()
RETURN
*---------------------------------------------------------------------------------------------------------------------------------
END
