* @ValidationCode : Mjo0OTAzNDAzMTY6Q3AxMjUyOjE2ODMwMjAyNDgyNjc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 15:07:28
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
SUBROUTINE REDO.TT.EFEC.ENV.BC.ME(V.DR.DENOMINATIO)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :btorresalbornoz
*Program   Name    :REDO.TT.EFEC.ENV.BC.ME
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the SELL DESTINATION value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date:                        Reference           Modified By:                Modification History
*-----------------------------------------------------------------------------
* 04-04-2023    TSR-452565     VIJAYALAKSHMI S          Multiple problems present in the alignment of deal slips produced by teller versions
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       VM TO @VM, ++ TO +=, = TO EQ, F.READ TO CACHE.READ
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)


    FN.TELLER.DENOM = 'F.TELLER.DENOMINATION'
    F.TELLER.DENOM = ''
    CALL OPF(FN.TELLER.DENOM,F.TELLER.DENOM)

    V.DR.DENOMINATIO=''
    Y.VAR2      = 1
    Y.DENOM.NUM = 0
    W.DENOM     = R.NEW(TT.TE.DR.DENOM)
    Y.DENOM.NUM = DCOUNT(W.DENOM,@VM)
    W.UNIT = R.NEW(TT.TE.DR.UNIT)
    Y.DENOM.UNIT = DCOUNT(W.UNIT,@VM)

    Y.VAR1      = 1
    Y.VAR.FIJA=1

RETURN

*********
PROCESS:
*********


    DATA.FIJA=11


    LOOP

    WHILE Y.VAR.FIJA LE DATA.FIJA
        GOSUB ESTRUCTURA
        GOSUB SEGUNDA.ESTRUCTURA
        Y.VAR.FIJA += 1 ;*AUTO R22 CODE CONVERSION

    REPEAT

RETURN

********************************************************************************
ESTRUCTURA:
********************************************************************************

    BEGIN  CASE

    CASE Y.VAR.FIJA EQ '1'
        PART1= "Referencia:":SPACE(24):ID.NEW
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART1:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>

    CASE Y.VAR.FIJA EQ '2' ;*AUTO R22 CODE CONVERSION
        Y.VAULT = R.NEW(TT.TE.ACCOUNT.1)
        Y.VAULT=Y.VAULT[9,4]
        PART2="De Bóveda(Crédito):":SPACE(24):Y.VAULT
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART2:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>


    CASE Y.VAR.FIJA EQ '3'

        Y.ACCOUNT.2=FMT(R.NEW(TT.TE.ACCOUNT.2),"R#16")
        PART3= "Cta. Banco:":SPACE(20):Y.ACCOUNT.2
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART3:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>

    CASE Y.VAR.FIJA EQ '4'

        GOSUB ACCOUNT.NAME

        PART4= "Nombre Banco:":SPACE(2):Y.ACCOUNT.NAME
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART4:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>

    CASE Y.VAR.FIJA EQ '5'

        Y.REFERENCIA=FMT(R.NEW(TT.TE.THEIR.REFERENCE),"R#16")
        PART5= "No. Referencia Banco:":SPACE(10):Y.REFERENCIA
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART5:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>








    CASE Y.VAR.FIJA EQ '6'
        GOSUB CURRENCY.NAME
        Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
*TSR-452565
        Y.CURRENCY = FMT(Y.CURRENCY,"10R")
        PART6="Moneda:":SPACE(30):Y.CURRENCY
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART6:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>





    CASE Y.VAR.FIJA EQ '7'

        Y.MONTO=R.NEW(TT.TE.AMOUNT.FCY.1)
        Y.MONTO=FMT(Y.MONTO,"R2,#16")
        PART7="Monto :":SPACE(24):Y.MONTO
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART7:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



    CASE Y.VAR.FIJA EQ '8' ;*AUTO R22 CODE CONVERSION
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=SPACE(53):V.DR.DENOMINATIO<1,Y.VAR.FIJA>




    CASE Y.VAR.FIJA EQ '9'
        GET.DATE.TIME = R.NEW(TT.TE.DATE.TIME)
        GOSUB GET.DATE.TIME.INFO
        PART9="Fecha - Hora:":SPACE(19):GET.DATE.TIME
        V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART9:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



END CASE

RETURN

********************************************************************************
SEGUNDA.ESTRUCTURA:
********************************************************************************

    BEGIN CASE
        CASE Y.VAR.FIJA EQ '10'
            GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":R.NEW(TT.TE.TELLER.ID.1)
            GET.CO.CODE = FMT(GET.CO.CODE,"28R")
            PART10="Oficina - Cajero: ":SPACE(1):GET.CO.CODE
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART10:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>


        CASE Y.VAR.FIJA EQ '11'
            Y.COMENTARIO=R.NEW(TT.TE.NARRATIVE.2)[1,32]
            Y.COMENTARIO=FMT(Y.COMENTARIO,"R#32")

            PART11="Comentarios:":SPACE(3):Y.COMENTARIO
            V.DR.DENOMINATIO<1,Y.VAR.FIJA>=PART11:SPACE(6):V.DR.DENOMINATIO<1,Y.VAR.FIJA>



        CASE Y.VAR.FIJA EQ '12'
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=SPACE(53):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END
        CASE Y.VAR.FIJA EQ '13' ;*AUTO R22 CODE CONVERSION
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=SPACE(53):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END

        CASE Y.VAR.FIJA EQ '14'
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=SPACE(53):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END

        CASE Y.VAR.FIJA EQ '15'
            IF R.NEW(TT.TE.UNIT)<1,Y.VAR.FIJA> NE "0" THEN
                V.DR.DENOMINATIO<1,Y.VAR.FIJA>=SPACE(53):V.DR.DENOMINATIO<1,Y.VAR.FIJA>
            END


    END CASE

RETURN

********************************************************
ACCOUNT.NAME:
*******************************************************


    Y.ACCOUNT=R.NEW(TT.TE.ACCOUNT.2)

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,IA.ERR)

    Y.ACCOUNT.NAME =R.ACCOUNT<AC.SHORT.TITLE>
    Y.ACCOUNT.NAME=  Y.ACCOUNT.NAME[1,32]
    Y.ACCOUNT.NAME=FMT(Y.ACCOUNT.NAME,"R,#32")

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
    CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, Y.ERR) ;*AUTO R22 CODE CONVERSION
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

        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
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
    Y.UNIT = FMT(Y.UNIT,"5R")
*TSR-452565
    Y.VALUE = Y.UNIT * DEN.VALUE
    V.DR.VALUE=FMT(Y.VALUE,"R2,#19")


RETURN


END