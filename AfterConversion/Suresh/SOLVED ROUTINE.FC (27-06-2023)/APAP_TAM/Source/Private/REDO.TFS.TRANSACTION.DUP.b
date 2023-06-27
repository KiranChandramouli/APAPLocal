* @ValidationCode : MjotNjE5MDkyMzEwOkNwMTI1MjoxNjg3Nzg0MjA4NTI0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2023 18:26:48
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
SUBROUTINE REDO.TFS.TRANSACTION.DUP
*--------------------------------------------------
* Description: This is the Validation routine for the TFS to avoid the duplicate
*               of TRANSACTION.
*--------------------------------------------------
* Date          Who              Reference                      Comments
* 14 Apr 2013  H Ganesh         PACS00255601 - TFS ISSUE       Initial Draft
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*26/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             NOCHANGE
*26/06/2023      SURESH                     MANUAL R22 CODE CONVERSION          Variable name modified
*----------------------------------------------------------------------------------------
*--------------------------------------------------

 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*   $INSERT I_F.T24.FUND.SERVICES           ;*R22 MANUAL CODE CONVERSION

    GOSUB PROCESS

RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------


    IF FIELD(OFS$HOT.FIELD,'.',1) EQ 'TRANSACTION' THEN
*       R.NEW(TFS.WAIVE.CHARGE)<1,AV> = 'NO' ;*R22 MANUAL CODE CONVERSION  ;*Because of commented 'I_F.T24.FUND.SERVICES' insert file, Comment this variable 'TFS.WAIVE.CHARGE'
    END

    LOCATE COMI IN R.NEW(TFS.TRANSACTION)<1,1> SETTING POS THEN
        IF POS NE AV THEN
            ETEXT = 'SC-DUPLICATES.NOT.ALLOW'
            CALL STORE.END.ERROR
        END

    END


RETURN
END
