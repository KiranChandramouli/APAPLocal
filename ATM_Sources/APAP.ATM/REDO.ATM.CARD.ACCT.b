
* @ValidationCode : MjotMTQwOTc3NzI2MjpDcDEyNTI6MTY5MzgxODA5NzMxOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Sep 2023 14:31:37
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
$PACKAGE APAP.ATM

 
SUBROUTINE REDO.ATM.CARD.ACCT(CARD.NUMM,RET.VAL)
*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE TAM.BP I_F.LATAM.CARD.ORDER
*    $INCLUDE TAM.BP I_F.REDO.CARD.BIN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.BIN         ;*/ TUS END

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.E.NOF.INAO.RTE.TXNS
* ODR NUMBER    : ODR-2009-10-0472
*-------------------------------------------------------------------------

* Description : This routine is used to fetch the account number from card number of customer

* In parameter : None
* out parameter : None

*----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                         REFERENCE                  DESCRIPTION
*                BALAGURUNATHAN B             ODR-2010-08-0469           INITIAL CREATION
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

* -----------------------------------------------------------------------------------------------------

    GOSUB OPEN.FILES

    GOSUB PROCESS


RETURN
*----------
OPEN.FILES:
*----------
    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'

    FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'

    F.LATAM.CARD.ORDER=''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)
    R.LATAM.CARD.ORDER=''
RETURN

*------
PROCESS:
*------

    CALL CACHE.READ(FN.REDO.CARD.BIN,CARD.NUMM[1,6],R.REDO.CARD.BIN,ERR)

    Y.CARD.ID=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
*changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279
    LOOP
        REMOVE CRD.TYP FROM Y.CARD.ID SETTING POS.CRD
    WHILE CRD.TYP:POS.CRD

        CARD.ID  =  CRD.TYP:'.' : CARD.NUMM

        CALL F.READ(FN.LATAM.CARD.ORDER,CARD.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ERR.CARD)
        IF R.LATAM.CARD.ORDER THEN
            RET.VAL=R.LATAM.CARD.ORDER<CARD.IS.ACCOUNT>
            RETURN
        END

    REPEAT
*changing code end to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279
RETURN





END
