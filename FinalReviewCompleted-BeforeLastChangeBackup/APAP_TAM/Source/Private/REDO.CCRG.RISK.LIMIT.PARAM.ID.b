* @ValidationCode : MjotODk3MDIzNTgzOkNwMTI1MjoxNjgwNjcxNzU1ODk5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:55
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
SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.ID
*-----------------------------------------------------------------------------
*!** FIELD definitions FOR TEMPLATE
* This routine validates the ID corresponding to the IDs of the virtual table
* REDO.CCRG.LIMIT registered in EB.LOOKUP application
*!
* @author:        anoriega@temenos.com
* @stereotype id: SubroutIne
* @package:       REDO.CCGR
* @uses:          ID.NEW, E
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    EB.LOOKUP.ID = ''
    R.EB.LOOKUP  = ''
    YERR         = ''
    EB.LOOKUP.ID = 'REDO.CCRG.LIMIT*' : ID.NEW
    CALL CACHE.READ('F.EB.LOOKUP',EB.LOOKUP.ID,R.EB.LOOKUP,YERR)
    IF NOT(R.EB.LOOKUP)THEN
        E = 'ST-REDO.CCRG.ID.LIMIT.IS.NOT.ALLOWED' : @FM : ID.NEW
    END
RETURN
END
