* @ValidationCode : MjoxMzc4MDQyNDIzOkNwMTI1MjoxNjgwNjE3NTAzMjg1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 19:41:43
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
SUBROUTINE MULTI.TXN.SERVICE.CHECK.RTN
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to retrive the informations from multiple files
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
* 04.04.2023    Conversion Tool         R22             Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M         R22             Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.TELLER.ID

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*--------------------------------------------------------------------------------------
INIT:
*--------------------------------------------------------------------------------------

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = '' ; REDO.MTS.TELLER.ID1 = ''
RETURN
*--------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------

    CALL OPF(FN.TELLER.USER,F.TELLER.USER)
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

RETURN
*--------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------

    CALL F.READ(FN.TELLER.USER,OPERATOR,R.TELLER.USER,F.TELLER.USER,TE.ERR)

    IF R.TELLER.USER EQ '' THEN
        E = 'TT-TID.TILL.NOT.EXIST.CURRENT.USER'
    END ELSE
        CALL F.READ(FN.TELLER.ID,R.TELLER.USER<1>,R.TELLER.ID,F.TELLER.ID,TELLER.ID.ERR)
        IF R.TELLER.ID<TT.TID.STATUS> NE 'OPEN' THEN
            E = 'TT-TILL.NOT.OPEN'
        END ELSE
            R.NEW(REDO.MTS.TELLER.ID) = R.TELLER.USER<1>
        END
    END
RETURN
*--------------------------------------------------------------------------------------
END
