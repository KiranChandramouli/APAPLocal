* @ValidationCode : MjotMjEyMzQzMDc2OTpDcDEyNTI6MTY4NDg1NTYwMzE0MzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:56:43
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
$PACKAGE APAP.PACS
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  $INCLUDE to $INSERT, TAM.BP REMOVED
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION BATCH.BUILD.LIST changed
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.CORRECTION.DIRECT.DEBIT.SELECT


    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_REDO.CORRECTION.DIRECT.DEBIT.COMMON
    $USING EB.Service



    SEL.CMD = "SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
*    CALL BATCH.BUILD.LIST('', SEL.LIST)
    EB.Service.BatchBuildList('', SEL.LIST)     ;*MANUAL R22 CODE CONVERSION



RETURN

END
