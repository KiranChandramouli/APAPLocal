* @ValidationCode : MjoxODA1NTA3MzM2OkNwMTI1MjoxNjgwNjkxMTE1MjI4OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 16:08:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.ACCT.ITEM
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.GROUP
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE                   WHO              REFERENCE                    DESCRIPTION
*27-05-2011        Sudharsanan S       PACS00062653                   Initial Creation
*05-04-2023       Conversion Tool      R22 Auto Code conversion          No Changes
*05-04-2023          Samaran T         Manual R22 Code Conversion        No Changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.REASSIGNMENT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS1
RETURN
*---
INIT:
*---

    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
    FN.REDO.H.MAIN.COMPANY ='F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

RETURN

*---------------------------------------------------------------------------------------
PROCESS1:
*---------------------------------------------------------------------------------------
    Y.GROUP = R.NEW(RE.ASS.DEPT)
    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
    Y.CODE = R.NEW(RE.ASS.CODE)
    LOCATE Y.CODE IN R.REDO.H.MAIN.COMPANY<REDO.COM.CODE,1> SETTING POS.1.1 THEN
        R.NEW(RE.ASS.DEPT.DES) = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION,POS.1.1>

    END
RETURN

END
