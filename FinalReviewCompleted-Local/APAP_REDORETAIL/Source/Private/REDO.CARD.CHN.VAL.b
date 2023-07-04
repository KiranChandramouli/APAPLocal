* @ValidationCode : Mjo0NTQ2ODIwMjE6Q3AxMjUyOjE2ODE4MjgwMDI3NDI6SVRTUzotMTotMTozNzk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 379
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM , FM TO @FM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.CARD.CHN.VAL
**********************************************************************
*  COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*  DEVELOPED BY: S DHAMU
*  PROGRAM NAME: REDO.CARD.CHN.VAL
*  ODR NO      : ODR-2010-08-0469
* ----------------------------------------------------------------------
*  DESCRIPTION: This routine is to validate whethere the card is allowed to do
*  transaction in MO.TO,internet


*    IN PARAMETER: NA
*    OUT PARAMETER: NA
*    LINKED WITH: NA
*----------------------------------------------------------------------
*   Modification History :
*   -----------------------
*    DATE           WHO           REFERENCE         DESCRIPTION
*    22.11.2010   S DHAMU     ODR-2010-08-0469   INITIAL CREATION
*    14.7.2011    Balagurunathan ODR-2010-08-0469 PACS00082637 fielD CHANNEL.DENY was not mapped properly
*    01.08.2011   Balagurunathan PACS00087222     Restricted locate to channel denay when the field doesnt have values
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.BIN


    IF V$FUNCTION EQ 'R' OR MESSAGE NE '' THEN

        RETURN

    END
    GOSUB INIT
    GOSUB PROCESS
RETURN


*****
INIT:
*****

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
    F.REDO.CARD.BIN=''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN )

RETURN

********
PROCESS:
********


    APL.ARRAY = APPLICATION
    APL.FIELD = 'AT.UNIQUE.ID':@VM:'AT.AUTH.CODE':@VM:'POS.COND'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.AT.UNIQUE.ID.POS = FLD.POS<1,1>
    LOC.AT.AUTH.CDE.POS=FLD.POS<1,2>
    LOC.POS.COND=FLD.POS<1,3>

    BEGIN CASE

        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            L.REF=FT.LOCAL.REF

        CASE APPLICATION EQ 'AC.LOCKED.EVENTS'
            L.REF=AC.LCK.LOCAL.REF
    END CASE

    POS.COND.VAL = R.NEW(L.REF)<1,LOC.POS.COND>

    CARD.NUMBER  = R.NEW(L.REF)<1,LOC.L.AT.UNIQUE.ID.POS>
    R.NEW(L.REF)<1,LOC.AT.AUTH.CDE.POS>=FIELD(CARD.NUMBER,'.',2)
*Based on application retrieve the value of field

    CARD.ORDER.ID=FIELD( CARD.NUMBER,'.',1 )
    BIN.NO=CARD.ORDER.ID[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,BIN.NO,R.REDO.CARD.BIN,F.REDO.CARD.BIN,BIN.ERR)
    Y.CARD.ID=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    Y.FLAG.POS=0
* changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279
    LOOP
        REMOVE CRD.TYP FROM Y.CARD.ID SETTING POS.CRD

    WHILE CRD.TYP:POS.CRD

        IF NOT(FLAG.LOOP) THEN
            Y.CARD.ORDER.ID = CRD.TYP:'.':CARD.ORDER.ID
            CALL F.READ(FN.LATAM.CARD.ORDER,Y.CARD.ORDER.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ORDER.ERR)
            IF R.LATAM.CARD.ORDER THEN
                CARD.ORDER.ID=Y.CARD.ORDER.ID
                Y.CARD.ID=CRD.TYP
                FLAG.LOOP=1
            END
        END
    REPEAT

*changing end code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279

*    CARD.ORDER.ID=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>:'.':CARD.ORDER.ID
*    CALL F.READ(FN.LATAM.CARD.ORDER,CARD.ORDER.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,ORDER.ERR)
    CHANNEL.DENAY = R.LATAM.CARD.ORDER<CARD.IS.CHANNEL.DENY>
*PACS00087222 S
    IF CHANNEL.DENAY NE '' THEN
*PACS00087222 E
        LOCATE POS.COND.VAL IN CHANNEL.DENAY<1,1> SETTING COND.POS THEN
            ETEXT = 'ST-INVALID.TXN.FOR.CARD'
            CALL STORE.END.ERROR

        END
    END

RETURN

END
