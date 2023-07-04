* @ValidationCode : MjotMTY2MzY1NjkxMTpDcDEyNTI6MTY4NDgzNjAzNjgyODpJVFNTOi0xOi0xOi01OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DEAL.CONV.NAME(Y.NAME)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.APAP.DEAL.CONV.NAME
*Reference Number  : ODR-2007-10-0074
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Inputter name and format them
*
*LINKED WITH       :
*Modification
* Date                  who                   Reference              
* 05-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    GOSUB PROCESS
RETURN

PROCESS:

    VAR.NAME = R.NEW(FX.INPUTTER)
    Y.NAME = FIELD(VAR.NAME,'_',2)

RETURN
END
