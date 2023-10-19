* @ValidationCode : MjotMTAxNzc0MjkwNjpDcDEyNTI6MTY4MTgwNTYwNDEzNzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 13:43:24
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.ACCT.ITEM
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the versions as
* a validation routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.ITEM.STOCK.CAL
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, SM TO @SM, F.READ TO CACHE.READ
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.REASSIGNMENT
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.REDO.H.INVENTORY.PARAMETER ='F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''
*CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER) ;*Tus S/E

    CALL CACHE.READ(FN.REDO.H.INVENTORY.PARAMETER,'SYSTEM',R.REDO.H.INVENTORY.PARAMETER,Y.ERR.INV)
    FN.REDO.H.PASSBOOK.INVENTORY = 'F.REDO.H.PASSBOOK.INVENTORY'
    F.REDO.H.PASSBOOK.INVENTORY = ''
    CALL OPF(FN.REDO.H.PASSBOOK.INVENTORY,F.REDO.H.PASSBOOK.INVENTORY)

    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES =''
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)

    APP = 'ACCOUNT'
    FIL.NAME = 'L.SERIES.ID'
    POS.LOC = ''
    CALL MULTI.GET.LOC.REF(APP,FIL.NAME,POS.LOC)
    SERIS.PO = POS.LOC<1,1>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ACCOUNT = COMI

*PACS00260041 - S
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ACCOUNT,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR)
    COUNT.LIST = DCOUNT(R.REDO.ITEM.SERIES,@FM)
    Y.ACCOUNT.LIST = FIELDS(R.REDO.ITEM.SERIES,'-',1,1)
    Y.PASS.LIST = FIELDS(R.REDO.ITEM.SERIES,'-',2,1)
    Y.ID = Y.PASS.LIST<COUNT.LIST>
    IF NOT(Y.ID) THEN
        ETEXT = 'EB-ACCT.NOT.EXISTS'
        GOSUB ERROR.THROW
    END ELSE
*PACS00260041 - E
        CALL F.READ(FN.REDO.H.PASSBOOK.INVENTORY,Y.ID,R.REDO.H.PASSBOOK.INVENTORY,F.REDO.H.PASSBOOK.INVENTORY,Y.ERR)
        Y.ITEM = R.REDO.H.PASSBOOK.INVENTORY<REDO.PASS.ITEM.CODE>
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.ACCT.ERR)

        Y.SERIES = R.ACCOUNT<AC.LOCAL.REF,SERIS.PO>
        CHANGE @VM TO @SM IN Y.SERIES
        Y.CNT = DCOUNT(Y.SERIES,@SM)
        Y.CAT.INV = R.REDO.H.INVENTORY.PARAMETER<IN.PR.PROD.CATEG>
        CHANGE @VM TO @FM IN Y.CAT.INV
        Y.NAME = R.ACCOUNT<AC.SHORT.TITLE>
        Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>

        CALL CACHE.READ(FN.CATEGORY, Y.CATEGORY, R.CATEGORY, Y.CAT.ERR)
        Y.DESCRIPTION = R.CATEGORY<EB.CAT.SHORT.NAME>
        R.NEW(RE.ASS.SERIES) = Y.SERIES<1,1,Y.CNT>
        R.NEW(RE.ASS.ITEM.CODE) = Y.ITEM
        R.NEW(RE.ASS.ACCOUNT.NAME) = Y.NAME
        R.NEW(RE.ASS.DESCRIPTION) = Y.DESCRIPTION
    END

RETURN
*-----------------------------------------------------------------------------------------
ERROR.THROW:
*-----------------------------------------------------------------------------------------
    AF =  RE.ASS.ACCOUNT.NUMBER
    CALL STORE.END.ERROR
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
END
