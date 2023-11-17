* @ValidationCode : MjoxNjAwNDExOTMzOkNwMTI1MjoxNjgxODI5MDkzNjkyOklUU1M6LTE6LTE6MTg1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.CHK.CPY(Y.TRANS.ID)
**********************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
*---------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.DS.CHK.CPY
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------------------------------
* Description : This is a conversion routine which gets the value of Transaction number
**********************************************************************************************
*Linked With :
*In parameter :
*Out parameter :
********************************************************************************************


    GOSUB INIT
    GOSUB PROCESS

RETURN

****
INIT:
*****

    FN.REDO.APAP.H.DEAL.SLIP.QUEUE = 'F.REDO.APAP.H.DEAL.SLIP.QUEUE'
    F.REDO.APAP.H.DEAL.SLIP.QUEUE  = ''
    CALL OPF(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,F.REDO.APAP.H.DEAL.SLIP.QUEUE)

RETURN


********
PROCESS:
*********

    CALL F.READ(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,Y.TRANS.ID,R.REDO.APAP.H.DEAL.SLIP.QUEUE,F.REDO.APAP.H.DEAL.SLIP.QUEUE,QUEUE.ERR)

    Y.PRINT = R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.INIT.PRINT>


    IF Y.PRINT EQ 'YES' THEN
        Y.TRANS.ID = 'COPIA'
    END ELSE
        Y.TRANS.ID = ''
    END

RETURN
****************************************************************************************************
END
