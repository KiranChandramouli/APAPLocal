SUBROUTINE REDO.V.LATAM.CHK.CARD

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a VALIDATION routine for LATAM.CARD.ORDER which will check whether the field CARD.LINKED is inputted with value
*of issuing card number
*Linked With  : LATAM.CARD.ORDER,REDO.PRINCIPAL
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 14 Apr 2011    Balagurunathan       ODR-2010-03-0400          Initial Creation
* 13-MAY-2011       KAVITHA             ODR-2010-08-0467          PACS00055017  FIX
* 07 SEP 2011       KAVITHA             PACS00126010              PACS00126010 FIX
* 01 OCT 2011    Balagurunathan         PACS00121355            recompiled to make validation function
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.CARD.RENEWAL

    FN.REDO.CARD.NUMBERS='F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS=''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    FN.REDO.CARD.RENEW = 'F.REDO.CARD.RENEWAL'
    F.REDO.CARD.RENEW = ''
    CALL OPF(FN.REDO.CARD.RENEW,F.REDO.CARD.RENEW)

    PRINCIPAL.AVAIL = ''



    REDO.CARD.REC=FIELD(ID.NEW,'.',1):'.':ID.COMPANY

    CALL F.READ(FN.REDO.CARD.NUMBERS,REDO.CARD.REC,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,ERR)

    CRD.NUMBER = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>


    CARD.NUM=R.NEW(CARD.IS.CARD.LINKED)
    ID.VALUE=FIELD(ID.NEW,'.',2)


    LOCATE ID.VALUE IN CRD.NUMBER<1,1> SETTING CRD.POS THEN

        EMBOSS.TYPE=R.REDO.CARD.NUMBERS< REDO.CARD.NUM.EMBOSS.TYPE,CRD.POS>

    END

    CRD.STATUS=R.NEW(CARD.IS.CARD.STATUS)

*PACS00055017-S
    IF EMBOSS.TYPE EQ 'PREEMBOZADA'AND CRD.STATUS EQ 90 THEN

        IF ID.VALUE NE CARD.NUM THEN

            AF=CARD.IS.CARD.LINKED
            ETEXT='ST-INVALID.CARD.NUM'
            CALL STORE.END.ERROR
        END

    END
*PACS00055017-E

*PACS00126010-S

    IF CRD.STATUS EQ 90 AND R.NEW(CARD.IS.TYPE.OF.CARD) EQ "ADICIONAL" THEN

        CARD.RENEW.ID = R.NEW(CARD.IS.CUSTOMER.NO)<1,2>:"-":R.NEW(CARD.IS.ACCOUNT)
        CALL F.READ(FN.REDO.CARD.RENEW,CARD.RENEW.ID,R.REDO.CARD.RENEW,F.REDO.CARD.RENEW,RENEW.ERR)
        IF R.REDO.CARD.RENEW THEN
            TYPE.OF.CARD = R.REDO.CARD.RENEW<REDO.RENEW.TYPE.OF.CARD>

            GET.CARD.NUMB.PREV = R.REDO.CARD.RENEW<REDO.RENEW.PREV.CARD.NO>
            GET.CARD.NO.STATUS = R.REDO.CARD.RENEW<REDO.RENEW.STATUS>

            CHANGE @VM TO @FM IN TYPE.OF.CARD
            CHANGE @VM TO @FM IN GET.CARD.NUMB.PREV
            CHANGE @VM TO @FM IN GET.CARD.NO.STATUS

            TOT.CNTR = DCOUNT(TYPE.OF.CARD,@FM)

            LOOP.CNTR = 1
            LOOP
            WHILE LOOP.CNTR LE TOT.CNTR

                GOSUB LOCATE.VALUES
                LOOP.CNTR += 1

            REPEAT
        END


        IF PRINCIPAL.AVAIL NE 'Y' THEN
            AF=CARD.IS.TYPE.OF.CARD
            ETEXT='EB-NO.PRINC.CARD'
            CALL STORE.END.ERROR
        END
    END

RETURN
*PACS00126010-E
*--------------------
LOCATE.VALUES:

    LOCATE "PRINCIPAL" IN TYPE.OF.CARD SETTING POS THEN

        CARD.NUMB.PREV = GET.CARD.NUMB.PREV<POS>
        CARD.NO.STATUS = GET.CARD.NO.STATUS<POS>

        IF CARD.NO.STATUS EQ 94 OR CARD.NO.STATUS EQ 90 THEN
            R.NEW(CARD.IS.CARD.NUMBER)<1,2> = CARD.NUMB.PREV
            PRINCIPAL.AVAIL = "Y"
            GOSUB END.PGM
        END ELSE
            DEL TYPE.OF.CARD<POS>
            DEL GET.CARD.NUMB.PREV<POS>
            DEL GET.CARD.NO.STATUS<POS>

        END

    END


RETURN
*---------------
END.PGM:

END
