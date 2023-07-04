* @ValidationCode : MjoxODU1MjU3NzU5OkNwMTI1MjoxNjgyMzM1OTQ0NjczOklUU1M6LTE6LTE6ODMxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 831
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           BP REMOVED, VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.APLICA.COM.RETIRO.RT
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START BP REMOVED
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.ACCOUNT
    $INSERT I_System ;* AUTO R22 CODE CONVERSION END

    Y.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)

    GOSUB INIT
    GOSUB PROCESS

RETURN

**********
INIT:
**********

    FN.ACCOUNT = "F.ACCOUNT"; F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.LATAM.CARD.CUSTOMER = "F.LATAM.CARD.CUSTOMER"; F.LATAM.CARD.CUSTOMER = ""
    CALL OPF(FN.LATAM.CARD.CUSTOMER, F.LATAM.CARD.CUSTOMER)

    FN.LATAM.CARD.ORDER = "F.LATAM.CARD.ORDER"; F.LATAM.CARD.ORDER = ""
    CALL OPF(FN.LATAM.CARD.ORDER, F.LATAM.CARD.ORDER)

RETURN

*********
PROCESS:
*********

    LREF.POS   = ''
    LREF.FIELD = 'L.INITIAL.ID':@VM:'L.NEXT.VERSION'
    CALL MULTI.GET.LOC.REF('TELLER',LREF.FIELD,LREF.POS)

    POS.L.INITIAL.ID = LREF.POS<1,1>
    POS.L.NEXT.VERSION = LREF.POS<1,2>
    Y.L.INITIAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.INITIAL.ID>
    Y.L.NEXT.VERSION = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.NEXT.VERSION>

    IF Y.L.NEXT.VERSION NE '' THEN
        GOSUB EXONERAR.COM
        RETURN
    END

    IF Y.L.INITIAL.ID EQ ID.NEW THEN
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)

        IF R.ACCOUNT THEN
            Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

            SEL.LIST = ""; NO.REC = ""; ERR = ""; SEL.CMD = ""

            SEL.CMD = "SELECT ":FN.LATAM.CARD.CUSTOMER : " WITH @ID EQ '" : Y.CUSTOMER: "' AND ACCOUNT.NO EQ '": Y.ACCOUNT :"'"
            CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, ERR)

            IF NO.REC GT 0 THEN
                CALL F.READ(FN.LATAM.CARD.CUSTOMER,Y.CUSTOMER,R.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER,Y.ERR.LCC)

                Y.ACCOUNTS.ARRAY = FIELD(R.LATAM.CARD.CUSTOMER, @FM, 2)
                Y.CARDS.ARRAY = FIELD(R.LATAM.CARD.CUSTOMER, @FM, 1)

                Y.ACCOUNTS.ARRAY = CHANGE(Y.ACCOUNTS.ARRAY, @VM, @FM)
                Y.CARDS.ARRAY = CHANGE(Y.CARDS.ARRAY, @VM, @FM)
                Y.TOTAL.ACC = DCOUNT(Y.ACCOUNTS.ARRAY, @FM)

                Y.LOOP1 = 1

                LOOP
                WHILE Y.LOOP1 LE Y.TOTAL.ACC
                    IF Y.ACCOUNTS.ARRAY<Y.LOOP1> NE '' THEN
                        IF Y.ACCOUNT NE Y.ACCOUNTS.ARRAY<Y.LOOP1> THEN

*                     Removemos del array las cuentas que no nos interesan.
                            DEL Y.ACCOUNTS.ARRAY<Y.LOOP1>
                            DEL Y.CARDS.ARRAY<Y.LOOP1>

*                     Como acabamos de remover un elemento, debemos evaluar nuevamente al que toma su lugar.
                            Y.LOOP1 -= 1
                        END ELSE
                            Y.CURR.CARD = Y.CARDS.ARRAY<Y.LOOP1>
                            CALL F.READ(FN.LATAM.CARD.ORDER,Y.CURR.CARD,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.ERR.LCO)
                            Y.CURR.TYPE = R.LATAM.CARD.ORDER<CARD.IS.TYPE.OF.CARD>
                            Y.CURR.STATUS = R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS>

                            IF Y.CURR.TYPE NE 'PRINCIPAL' THEN

*                        Removemos del array las tarjetas no principales.
                                DEL Y.ACCOUNTS.ARRAY<Y.LOOP1>
                                DEL Y.CARDS.ARRAY<Y.LOOP1>

*                        Como acabamos de remover un elemento, debemos evaluar nuevamente al que toma su lugar.
                                Y.LOOP1 -= 1
                            END ELSE
                                Y.CARDS.ARRAY<Y.LOOP1> = Y.CARDS.ARRAY<Y.LOOP1> : @VM : Y.CURR.STATUS
                            END
                        END
                    END

                    Y.LOOP1 += 1 ;* AUTO R22 CODE CONVERSION
                REPEAT

                Y.TOTAL.ACC = DCOUNT(Y.ACCOUNTS.ARRAY, @FM)

*            Con esto combinado con la logica del bucle, obtenemos la ultima tarjeta principal de la cuenta y su estatus.
                Y.LAST.CARD.ITEM = Y.CARDS.ARRAY<Y.TOTAL.ACC>
                Y.LAST.CARD.ITEM = CHANGE(Y.LAST.CARD.ITEM, @VM, @FM)
                Y.STATUS = Y.LAST.CARD.ITEM<2>

*            El status 93 es cancelada y el estatus 97 es matured. En el caso ET-4695 se solicito excluirlos.
                IF Y.STATUS EQ 93 OR Y.STATUS EQ 97 THEN
                    GOSUB EXONERAR.COM
                END

            END ELSE
                GOSUB EXONERAR.COM
            END
        END
    END ELSE
        GOSUB EXONERAR.COM
    END

RETURN

*************
EXONERAR.COM:
*************
    R.NEW(TT.TE.WAIVE.CHARGES) = 'YES'
    R.NEW(TT.TE.CHARGE.ACCOUNT) = ''
    R.NEW(TT.TE.CHRG.AMT.LOCAL) = ''

*   Para evitar conflicto con next version y monto del cajero MDP-957
    CALL System.setVariable("CURRENT.WTM.RESULT","0")

RETURN

END
