* @ValidationCode : MjotMTA2ODYwNTExOlVURi04OjE3MDQ5NjgwMzA3MDA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 15:43:50
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TT.VAULT.TO.VAUL.ME(V.DR.DENOMINATIO)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :btorresalbornoz
*Program Name :REDO.TT.VAULT.TO.VAUL.ME TT
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the SELL DESTINATION value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
* ----------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date:                        Reference           Modified By:                Modification History
*-----------------------------------------------------------------------------
* 04-04-2023    TSR-452565     VIJAYALAKSHMI S          Multiple problems present in the alignment of deal slips produced by teller versions
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, F TO CACHE, ++ TO += 1, = TO EQ
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.USER
    $INSERT I_F.TELLER.DENOMINATION
    $INSERT I_F.CURRENCY
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $USING EB.LocalReferences
    GOSUB INITIALISE
    GOSUB DENOMINATION
    GOSUB PROCESS
RETURN

* =========
INITIALISE:
* =========
*

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)


    FN.TELLER.DENOM = 'F.TELLER.DENOMINATION'
    F.TELLER.DENOM = ''
    CALL OPF(FN.TELLER.DENOM,F.TELLER.DENOM)

    V.DR.DENOMINATIO=''
    Y.VAR2 = 1
    Y.DENOM.NUM = 0
    W.DENOM = R.NEW(TT.TE.DENOMINATION)
    Y.DENOM.NUM = DCOUNT(W.DENOM,@VM)
    W.UNIT = R.NEW(TT.TE.DR.UNIT)
    Y.DENOM.UNIT = DCOUNT(W.UNIT,@VM)

    Y.VAR1 = 1
    Y.VAR.FIJA=1

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.FIELD = 'L.TT.CONCEPT'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
*    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    EB.LocalReferences.GetLocRef(LOC.REF.APP,LOC.REF.FIELD,LOC.POS);* R22 UTILITY AUTO CONVERSION



RETURN



*********
PROCESS:
*********


    DATA.FIJA=12


    LOOP

    WHILE Y.VAR.FIJA LE DATA.FIJA
        GOSUB ESTRUCTURA


        GOSUB SEGUNDA.ESTRUCTURA
        Y.VAR.FIJA += 1                ;** R22 Auto conversion - ++ TO += 1

    REPEAT

RETURN

********************************************************************************
ESTRUCTURA:
********************************************************************************

    BEGIN CASE

        CASE Y.VAR.FIJA EQ '1'
            PART1= "Referencia:":SPACE(24):ID.NEW
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART1:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>

*        CASE Y.VAR.FIJA EQ '2'                  ;** R22 Auto conversion - = TO EQ
        CASE Y.VAR.FIJA EQ '2'                  ;** R22 Auto conversion - EQ TO EQ;* R22 UTILITY AUTO CONVERSION
            GOSUB TELLER.ID.USER
            PART2="De Bóveda (Crédito):":SPACE(23):R.NEW(TT.TE.TELLER.ID.2)
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART2:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>


        CASE Y.VAR.FIJA EQ '3'

            GOSUB ACCOUNT.NAME
            PART3= "A Bóveda(Débito):":SPACE(26):R.NEW(TT.TE.NARRATIVE.1)
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART3:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>


        CASE Y.VAR.FIJA EQ '4'
            GOSUB CURRENCY.NAME
            Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
*TSR-452565
            Y.CURRENCY = FMT(Y.CURRENCY,"10R")
            PART4="Moneda:":SPACE(30):Y.CURRENCY
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART4:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



        CASE Y.VAR.FIJA EQ '5'

            Y.MONTO=R.NEW(TT.TE.AMOUNT.FCY.1)
            Y.MONTO=FMT(Y.MONTO,"R2,#16")
            PART5="Monto :":SPACE(24):Y.MONTO
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART5:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



*        CASE Y.VAR.FIJA EQ '6'                ;** R22 Auto conversion - = TO EQ
        CASE Y.VAR.FIJA EQ '6'                ;** R22 Auto conversion - EQ TO EQ;* R22 UTILITY AUTO CONVERSION
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=SPACE(53):V.DR.DENOMINATIO<1,Y.VAR.FIJA>




        CASE Y.VAR.FIJA EQ '7'
            GET.DATE.TIME = R.NEW(TT.TE.DATE.TIME)
            GOSUB GET.DATE.TIME.INFO
            PART7="Fecha - Hora:":SPACE(19):GET.DATE.TIME
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART7:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



    END CASE

RETURN

********************************************************************************
SEGUNDA.ESTRUCTURA:
********************************************************************************

    BEGIN CASE
        CASE Y.VAR.FIJA EQ '8'
            GET.INP.ID = FIELD(R.NEW(TT.TE.INPUTTER),'_',2)
            GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":GET.INP.ID
            GET.CO.CODE = FMT(GET.CO.CODE,"28R")
            PART8="Oficina - Cajero: ":SPACE(1):GET.CO.CODE
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART8:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>


        CASE Y.VAR.FIJA EQ '9'
            Y.COMENTARIO = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>
            Y.COMENTARIO=FMT(Y.COMENTARIO,"R#32")

            PART9="Comentarios:":SPACE(3):Y.COMENTARIO
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART9:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



        CASE Y.VAR.FIJA EQ '10'

            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                Y.DENOMINATIO=V.DR.DENOMINATIO<1,Y.VAR.FIJA>

                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=" ":SPACE(52):Y.DENOMINATIO
            END

*        CASE Y.VAR.FIJA EQ '11'             ;** R22 Auto conversion - = TO EQ
        CASE Y.VAR.FIJA EQ '11'             ;** R22 Auto conversion - EQ TO EQ;* R22 UTILITY AUTO CONVERSION
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=" ":SPACE(52):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END

*        CASE Y.VAR.FIJA EQ '12'             ;** R22 Auto conversion - = TO EQ
        CASE Y.VAR.FIJA EQ '12'             ;** R22 Auto conversion - EQ TO EQ;* R22 UTILITY AUTO CONVERSION
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=" ":SPACE(52):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END

*        CASE Y.VAR.FIJA EQ '13'                 ;** R22 Auto conversion - = TO EQ
        CASE Y.VAR.FIJA EQ '13'                 ;** R22 Auto conversion - EQ TO EQ;* R22 UTILITY AUTO CONVERSION
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=" ":SPACE(52):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END


    END CASE

RETURN





*
********************************************************
TELLER.ID.USER:
*******************************************************

    Y.TELLER.ID2=R.NEW(TT.TE.TELLER.ID.1)

    CALL F.READ(FN.TELLER.ID,Y.TELLER.ID2,R.TELLER.ID,F.TELLER.ID,I.ERR)

    Y.USER=R.TELLER.ID<TT.TID.USER>


RETURN
**********************************************************
CURRENCY.NAME:
*********************************************************
    Y.CURRENCY=R.NEW(TT.TE.CURRENCY.1)
    CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, Y.ERR)             ;** R22 Auto conversion - F TO CACHE
    Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>

RETURN

**********************************************************
DENOMINATION:
**********************************************************
    Y.DENOMINATION=R.NEW(TT.TE.DENOMINATION)<1,Y.VAR1>
    Y.UNIT=R.NEW(TT.TE.UNIT)<1,Y.VAR1>

    LOOP
    WHILE Y.VAR1 LE Y.DENOM.NUM

        IF R.NEW(TT.TE.UNIT)<1,Y.VAR1> NE "0" THEN


            GOSUB GET.VALUE
            Y.DENOMINATION=R.NEW(TT.TE.DENOMINATION)<1,Y.VAR1>
            Y.DENOMINATION=FMT(Y.DENOMINATION,"11L")
            V.DR.DENOMINATIO<-1>=Y.DENOMINATION
            V.DR.DENOMINATIO= CHANGE(V.DR.DENOMINATIO,@FM,@VM)
*V.DR.DENOMINATIO=V.DR.DENOMINATIO:SPACE(10):R.NEW(TT.TE.UNIT)<1,Y.VAR1>:SPACE(3):V.DR.VALUE
*TSR-452565
            V.DR.UN = FMT(R.NEW(TT.TE.UNIT)<1,Y.VAR1>,"7R")
            V.DR.DENOMINATIO=V.DR.DENOMINATIO:SPACE(7):V.DR.UN:V.DR.VALUE
        END

        Y.VAR1 += 1    ;** R22 Auto conversion - ++ TO += 1
    REPEAT



RETURN

*----------------------------------------------
GET.DATE.TIME.INFO:
*----------------------------------------------

    F1 = GET.DATE.TIME[1,2]
    F2 = GET.DATE.TIME[3,2]
    F3 = GET.DATE.TIME[5,2]
    F4 = GET.DATE.TIME[7,2]
    F5 = GET.DATE.TIME[9,2]

    Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
    GET.DATE.TIME= FMT(Y.TIME,"15R")

RETURN

*************************************************
GET.VALUE:
*************************************************
    Y.DENOM=R.NEW(TT.TE.DENOMINATION)<1,Y.VAR1>
    Y.UNIT=R.NEW(TT.TE.UNIT)<1,Y.VAR1>
    CALL CACHE.READ(FN.TELLER.DENOM,Y.DENOM,R.TELLER.DENOM,DENOM.ERR)
    DEN.VALUE = R.TELLER.DENOM<TT.DEN.VALUE>
    Y.UNIT = FMT(Y.UNIT,"6R")
*TSR-452565
    Y.VALUE = Y.UNIT * DEN.VALUE
    V.DR.VALUE=FMT(Y.VALUE,"R2,#19")


RETURN



********************************************************
ACCOUNT.NAME:
*******************************************************


    Y.ACCOUNT=R.NEW(TT.TE.ACCOUNT.1)

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,IA.ERR)

    Y.ACCOUNT.NAME =R.ACCOUNT<AC.SHORT.TITLE>
    Y.ACCOUNT.NAME= Y.ACCOUNT.NAME[1,31]
    Y.ACCOUNT.NAME=FMT(Y.ACCOUNT.NAME,"R#32")
RETURN


END
