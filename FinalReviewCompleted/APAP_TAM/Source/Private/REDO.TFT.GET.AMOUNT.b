* @ValidationCode : MjotMTYxODM1OTM4OTpDcDEyNTI6MTY5MDE3NjEwMTg4NTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:51:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TFT.GET.AMOUNT(Y.FIELD.NAME)
*-------------------------------------------------------------
*Modification HISTORY:
*Description: This routine is call routine from deal slip of TT
*DATE			           AUTHOR		          Modification                            DESCRIPTION
*13/07/2023	               CONVERSION TOOL      AUTO R22 CODE CONVERSION		  VM TO @VM,FM TO @FM,SM TO @SM,F.READ TO CACHE.READ, = TO EQ, ++ TO +=1
*13/07/2023	               VIGNESHWARI      	MANUAL R22 CODE CONVERSION		      NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------------------
*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*-------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------------------------
    Y.AMOUNT1= 0
    Y.AMOUNT2=0
    Y.AMOUNT3=0
    Y.AMOUNT4=0

    BEGIN CASE
        CASE Y.FIELD.NAME EQ 'Y.CASHDEPD'
            GOSUB GET.CASHDEPD
            Y.FIELD.NAME = FMT(Y.AMOUNT1,"R,#20")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CCY'
            Y.CURRENCY = R.NEW(TFS.CURRENCY)
            FN.CURRENCY = 'F.CURRENCY'
            F.CURRENCY = ''
            CALL OPF(FN.CURRENCY,F.CURRENCY)

            CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, CURRENCY.ERR);*AUTO R22 CODE CONVERSION

            IF  Y.CURRENCY EQ 'DOP' THEN
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
                Y.CURRENCY="RD$(":Y.CURRENCY:")"
            END ELSE
                Y.CURRENCY=R.CURRENCY<EB.CUR.CCY.NAME>
            END
            Y.FIELD.NAME=FMT(Y.CURRENCY,"22R")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.FROM'
            GOSUB GET.FROM
            IF Y.AMOUNT2 THEN
                Y.FIELD.NAME = FMT(Y.AMOUNT2,"R,#20")
            END ELSE
                Y.FIELD.NAME = ''
            END

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CHQDEP'

            GOSUB GET.CHQDEP
            Y.FIELD.NAME = FMT(Y.AMOUNT3,"R,#20")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.NET.TXN.AMT'

            GOSUB GET.NET.TXN.AMT
            Y.FIELD.NAME = FMT(Y.AMOUNT4,"20R,2")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.DATE.TIME'
            GET.DATE.TIME = R.NEW(TFS.DATE.TIME)
            GOSUB GET.DATE.TIME.INFO

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.CO.CODE'
            GOSUB GET.CO.CODE
            RETURN


    END CASE


RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.NET.TXN.AMT:
*----------------------------------------------------------------------------------------------------------------------
    Y.AMOUNT4 = R.NEW(TFS.NET.TXN.AMT)
    Y.AMOUNT4= CHANGE(Y.AMOUNT4,@FM,@VM)
    Y.AMOUNT4= Y.AMOUNT4<1,1>
RETURN


*----------------------------------------------------------------------------------------------------------------------
GET.CASHDEPD:
*----------------------------------------------------------------------------------------------------------------------
    Y.WV1 = 1
    Y.TRANSACTION = R.NEW(TFS.TRANSACTION)
    Y.AMOUNT = R.NEW(TFS.AMOUNT)

    Y.WV.COUNT1 = DCOUNT(Y.TRANSACTION,@VM)

    LOOP
    WHILE Y.WV1 LE Y.WV.COUNT1
        IF Y.TRANSACTION<1,Y.WV1> EQ 'CASHDEPD' THEN
            Y.AMOUNT=Y.AMOUNT<1,Y.WV1>

        END ELSE

            IF Y.TRANSACTION<1,Y.WV1> EQ 'CASHDEP' THEN
                Y.AMOUNT1=Y.AMOUNT<1,Y.WV1>
            END
            IF Y.TRANSACTION<1,Y.WV1> EQ 'FCASHAZ' THEN
                Y.AMOUNT1 = Y.AMOUNT<1,Y.WV1>
            END
        END

        Y.WV1 += 1
    REPEAT

RETURN



*----------------------------------------------------------------------------------------------------------------------
GET.FROM:
*----------------------------------------------------------------------------------------------------------------------
    Y.WV2 = 1
    Y.TRANSACTION = R.NEW(TFS.TRANSACTION)
    Y.AMOUNT = R.NEW(TFS.AMOUNT)

    Y.WV.COUNT2 = DCOUNT(Y.TRANSACTION,@VM)

    LOOP
    WHILE Y.WV2 LE Y.WV.COUNT2
        IF Y.TRANSACTION<1,Y.WV2> EQ 'FROM' THEN
            Y.AMOUNT2=Y.AMOUNT<1,Y.WV2>


        END

        Y.WV2 += 1
    REPEAT

RETURN



*----------------------------------------------------------------------------------------------------------------------
GET.CHQDEP:
*----------------------------------------------------------------------------------------------------------------------
    Y.WV3 = 1
    Y.TRANSACTION = R.NEW(TFS.TRANSACTION)
    Y.AMOUNT = R.NEW(TFS.AMOUNT)

    Y.WV.COUNT3 = DCOUNT(Y.TRANSACTION,@VM)

    LOOP
    WHILE Y.WV3 LE Y.WV.COUNT3
        IF Y.TRANSACTION<1,Y.WV3> EQ 'CHQDEP' THEN
            Y.AMOUNT3=Y.AMOUNT<1,Y.WV3>


        END

        Y.WV3 += 1
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.DATE.TIME.INFO:
*----------------------------------------------------------------------------------------------------------------------

    F1 = GET.DATE.TIME[1,2]
    F2 = GET.DATE.TIME[3,2]
    F3 = GET.DATE.TIME[5,2]
    F4 = GET.DATE.TIME[7,2]
    F5 = GET.DATE.TIME[9,2]

    Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
    Y.FIELD.NAME = FMT(Y.TIME,"15R")

RETURN


*----------------------------------------------------------------------------------------------------------------------
GET.CO.CODE:
*----------------------------------------------------------------------------------------------------------------------

    TTTX.ID=R.NEW(TFS.UNDERLYING)
    TTTX.ID=CHANGE(TTTX.ID,@FM,@VM)
    TTTX.ID=CHANGE(TTTX.ID,@SM,@VM)
    TTTX.ID=TTTX.ID<1,1>

    FN.TELLER = 'F.TELLER'
    F.TELLER=''
    CALL OPF(FN.TELLER,F.TELLER)
    CALL F.READ(FN.TELLER,TTTX.ID,R.TELLER,F.TELLER,TTTX.ERR)

    IF R.TELLER THEN
        Y.TELLER.ID = R.TELLER<TT.TE.TELLER.ID.1>
    END ELSE
        Y.GET.INP.VAL = R.NEW(TFS.INPUTTER)
        Y.TELLER.ID = FIELD(Y.GET.INP.VAL,'_',2)
    END

    GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":Y.TELLER.ID
    Y.FIELD.NAME = FMT(GET.CO.CODE,"30R")

RETURN

*----------------------------------------------------------------------------------------------------------------------
END
