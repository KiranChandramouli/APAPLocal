* @ValidationCode : MjotMjEyMzQzMDc2OTpDcDEyNTI6MTY4MTg5MTYyNjE2OTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:37:06
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
$PACKAGE APAP.PACS
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  $INCLUDE to $INSERT, TAM.BP REMOVED
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.CORRECTION.DIRECT.DEBIT.SELECT


    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_REDO.CORRECTION.DIRECT.DEBIT.COMMON



    SEL.CMD = "SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    CALL BATCH.BUILD.LIST('', SEL.LIST)



RETURN

END
