* @ValidationCode : MjotMTY3MjU5MjI1MjpDcDEyNTI6MTY4MDYwNDQ1Mjc5ODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:04:12
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CAMPAIGN.GEN.ID
*-------------------------------------------------------------
* Company   Name    :Asociacion Popular de Ahorros y Prestamos
* Developed By      :PRADEEP.P
* ODR Number        :ODR-2010-08-0228
* Program   Name    :REDO.APAP.CAMPAIGN.GEN.ID
*---------------------------------------------------------------------------------
* DESCRIPTION       :This routine is the .ID routine for the local template
*                    REDO.APAP.CAMPAIGN.GEN
*
* ----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO             REFERENCE         DESCRIPTION
*  24-08-2010      Pradeep.P    ODR-2010-08-0228    INITIAL CREATION
* Date                  who                   Reference              
* 04-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CAMPAIGN.GEN

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*---
    FN.REDO.APAP.CAMPAIGN.GEN = 'F.REDO.APAP.CAMPAIGN.GEN'
    F.REDO.APAP.CAMPAIGN.GEN = ''
RETURN
*
OPENFILES:
*---------
    CALL OPF(FN.REDO.APAP.CAMPAIGN.GEN,F.REDO.APAP.CAMPAIGN.GEN)
RETURN
*
PROCESS:
*-------
*
    Y.DATE = COMI
    Y.TODAY = TODAY
    IF Y.DATE EQ Y.TODAY THEN
        RETURN
    END ELSE
        E = "EB-REC.BEF.TOD"
        CALL STORE.END.ERROR
    END
RETURN
END
