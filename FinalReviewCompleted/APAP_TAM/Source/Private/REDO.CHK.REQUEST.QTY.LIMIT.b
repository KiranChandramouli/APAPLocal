* @ValidationCode : MjoxNjc1Nzk5MzMwOkNwMTI1MjoxNjg0ODQyMDg3Nzk2OklUU1M6LTE6LTE6LTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CHK.REQUEST.QTY.LIMIT
*---------------------------------------
* Description : This validation routine is checks the request qty limit. If its exceeds 1000 then raise the error message.
*               The instruction of increasing cache size is given under the below pacs ticket.
* Issue Ref   : PACS00254644
*---------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS

    GOSUB PROCESS
RETURN
*-----------------------------------------
PROCESS:
*---------

    Y.REQ.QTY = COMI

    IF Y.REQ.QTY GT '1000' THEN
        ETEXT = 'EB-REDO.CHECK.REQUEST.INVENTORY'
        CALL STORE.END.ERROR
    END
RETURN
*-----------------
END
