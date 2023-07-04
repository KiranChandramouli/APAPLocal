* @ValidationCode : MjoyMDc4NDM4ODIwOkNwMTI1MjoxNjgyNDEyMzI2MzkwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.LATAM.RENEW.UPD
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.AUT.LATAM.RENEW.UPT
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is atatched to REDO.CARD.REQUEST,OFS to update latam card order
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO                 REFERENCE                      DESCRIPTION
*9.03.2011     JEEVA T            ODR-2010-03-0400               INITIAL CREATION
*04-04-2023  Conversion Tool      R22 Auto Code conversion        No Changes
*04-04-2023  Samaran T            Manual R22 Code Conversion      No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.LATAM.CARD.ORDER


    GOSUB OPEN.FILE
    GOSUB PROCESS.FILE
RETURN
*----------------------------------------------------------------------
OPEN.FILE:
*----------------------------------------------------------------------

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

RETURN
*----------------------------------------------------------------------
PROCESS.FILE:
*----------------------------------------------------------------------

    ISSUE.INDICATOR = ''
    COMMENTS = ''

    COMMENTS =   R.NEW(REDO.CARD.REQ.VAULT.QTY)<1,1>
    ISSUE.INDICATOR = TRIM(FIELD(COMMENTS,":",1))

    IF COMMENTS THEN
        GOSUB SUB.PROCESS
    END

RETURN
*----------------------------------------------------------------------
SUB.PROCESS:

    Y.ID.GEN = ID.NEW
    Y.PRIMARY = ''
    Y.CUS.PRIM  = ''
    Y.CUS.NUM = ''
    R.LATAM.CARD.ORDER.PRI = ''
    R.LATAM.CARD.ORDER = ''
    Y.RECORD = ''

    Y.LATAM.ID = TRIM(FIELD(COMMENTS,":",2))

    GOSUB LATAM.CARD.UPDATE

RETURN
*----------------------------------------------------------------------
LATAM.CARD.UPDATE:

    CALL F.READ(FN.LATAM.CARD.ORDER,Y.LATAM.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.ERR)

    IF R.LATAM.CARD.ORDER THEN
        IF R.NEW(REDO.CARD.REQ.RENEWAL.FLAG) EQ "YES" THEN
            R.LATAM.CARD.ORDER<CARD.IS.RENEWAL.COUNTER> =  R.LATAM.CARD.ORDER<CARD.IS.RENEWAL.COUNTER> + 1
            R.LATAM.CARD.ORDER<CARD.IS.RENEW.REQ.ID> = ID.NEW
        END ELSE
            R.LATAM.CARD.ORDER<CARD.IS.REISSUE.COUNTER> =  R.LATAM.CARD.ORDER<CARD.IS.REISSUE.COUNTER> + 1
        END
        CALL F.WRITE(FN.LATAM.CARD.ORDER,Y.LATAM.ID,R.LATAM.CARD.ORDER)
    END

RETURN
*----------------------------------------------------------------------
END
