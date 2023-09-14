* @ValidationCode : MjoxNDY3ODk2OTEyOkNwMTI1MjoxNjgxODI4MDAzMDgxOklUU1M6LTE6LTE6MTgzOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 183
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.DAMAGE.ID

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CARD.DAMAGE.ID
*--------------------------------------------------------------------------------
* Description: This is an ID routine for REDO.CARD.DAMAGE and it gets the Request
* ID from REDO.CARD.REQUEST based on entered card number
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 04-May-2011    H GANESH       PACS00054728    INITIAL CREATION
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CARD.DAMAGE.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------
    REQ.ID=''
    Y.CARD.TYPE=''
    ERR=''

    FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST=''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
* This part gets the REDO.CARD.REQUEST for card and assignt to ID.NEW

    REDO.CARD.TYPE= ''
    REDO.CARD.NO= ''

    Y.ID = ID.NEW     ;* Get the Latam Card No

    IF Y.ID[1,3] EQ 'REQ' THEN
        R.CARD.REQ=''
        CALL F.READ(FN.REDO.CARD.REQUEST,Y.ID,R.CARD.REQ,F.REDO.CARD.REQUEST,REQ.ERR)
        IF R.CARD.REQ EQ '' THEN
            E='EB-MISSING.RECORD':@FM:'REDO.CARD.REQUEST'
        END
        RETURN
    END
    CALL APAP.TAM.REDO.GET.CARD.REQUEST.ID(Y.ID,REQ.ID,Y.CARD.TYPE,ERR) ;*MANUAL R22 CODE CONVERSION

    IF ERR THEN
        E='EB-INVALID.CARD.NO'
        RETURN
    END
    REDO.CARD.TYPE=Y.CARD.TYPE
    REDO.CARD.NO=Y.ID
    ID.NEW=REQ.ID
RETURN
END
