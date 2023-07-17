* @ValidationCode : Mjo1NDgyMzk5Mzc6Q3AxMjUyOjE2ODMwMDE1MzM4Mjg6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 09:55:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TTI.FMT.DATE(Y.FIELD.NAME)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT...

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*-------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,F.READ TO CACHE.READ, = TO EQ, ++ TO +=1
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER.ID
    $INSERT I_F.CURRENCY
    $INSERT I_System

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    Y.CURRENCY = R.NEW(TT.TID.CURRENCY)
    Y.CURRENCY =  CHANGE(Y.CURRENCY,@SM,@VM)
    Y.CURRENCY =  CHANGE(Y.CURRENCY,@FM,@VM)

    BEGIN CASE

        CASE Y.FIELD.NAME EQ 'Y.CCY'
            Y.FIELD.NAME = ""
            Y.CURRENCY = CHANGE(Y.CURRENCY,@VM,@FM)
            Y.DIFFERENCE = R.NEW(TT.TID.DIFFERENCE)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @VM, @FM)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @SM, @FM)
            Y.CCY.CNT = 1
            LOOP
                REMOVE Y.CCY FROM Y.CURRENCY SETTING CCY.POS
            WHILE Y.CCY:CCY.POS
                IF Y.DIFFERENCE<Y.CCY.CNT> NE 0 THEN
                    CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY<Y.CCY.CNT>, R.CURRENCY, Y.ERR)     ;*R22 AUTO CODE CONVERSION
                    Y.CURRENCY.1=R.CURRENCY<EB.CUR.CCY.NAME>
                    IF Y.CURRENCY<Y.CCY.CNT> EQ 'DOP' THEN
                        Y.CURRENCY.1="RD$(":Y.CURRENCY.1:")"
                        Y.FIELD.NAME=FMT(Y.CURRENCY.1,"22R")
                    END ELSE
                        Y.FIELD.NAME=FMT(Y.CURRENCY.1,"22R")
                    END
                    Y.CURRENCY = ""
                END
                Y.CCY.CNT += 1
            REPEAT

            RETURN
        CASE Y.FIELD.NAME EQ 'Y.CCY2'
            Y.FIELD.NAME = ""
            Y.CURRENCY = CHANGE(Y.CURRENCY,@VM,@FM)
            Y.DIFFERENCE = R.NEW(TT.TID.DIFFERENCE)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @VM, @FM)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @SM, @FM)
            Y.CCY.CNT = 1
            Y.FOUND.CNT = 0

            LOOP
                REMOVE Y.CCY FROM Y.CURRENCY SETTING CCY.POS
            WHILE Y.CCY:CCY.POS
                IF Y.DIFFERENCE<Y.CCY.CNT> NE 0 THEN
                    Y.FOUND.CNT += 1
                    IF Y.FOUND.CNT EQ 2 THEN
                        CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY<Y.CCY.CNT>, R.CURRENCY, Y.ERR)       ;*R22 AUTO CODE CONVERSION
                        Y.CURRENCY.2=R.CURRENCY<EB.CUR.CCY.NAME>
                        IF Y.CURRENCY<Y.CCY.CNT> EQ 'DOP' THEN
                            Y.CURRENCY.2="RD$(":Y.CURRENCY.2:")"
                            Y.FIELD.NAME=FMT(Y.CURRENCY.2,"22R")
                        END ELSE
                            Y.FIELD.NAME=FMT(Y.CURRENCY.2,"22R")
                        END
                        Y.CURRENCY = ""
                    END

                END
                Y.CCY.CNT += 1
            REPEAT

            RETURN
        CASE Y.FIELD.NAME EQ 'Y.CCY3'
            Y.FIELD.NAME = ""
            Y.CURRENCY = CHANGE(Y.CURRENCY,@VM,@FM)
            Y.DIFFERENCE = R.NEW(TT.TID.DIFFERENCE)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @VM, @FM)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @SM, @FM)

            Y.CCY.CNT = 1
            Y.FOUND.CNT = 0
            LOOP
                REMOVE Y.CCY FROM Y.CURRENCY SETTING CCY.POS
            WHILE Y.CCY:CCY.POS
                IF Y.DIFFERENCE<Y.CCY.CNT> NE 0 THEN
                    Y.FOUND.CNT +=1
                    T.FIELD.NAME = ""
                    R.CURRENCY= ""
                    IF Y.FOUND.CNT GT 2 THEN
                        CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY<Y.CCY.CNT>, R.CURRENCY, Y.ERR)       ;*R22 AUTO CODE CONVERSION
                        Y.CURRENCY.3 = R.CURRENCY<EB.CUR.CCY.NAME>
                        IF Y.CURRENCY<Y.CCY.CNT> EQ 'DOP' THEN
                            Y.CURRENCY.3 = "RD$(":Y.CURRENCY.3:")"
                            T.FIELD.NAME = Y.CURRENCY.3
                        END ELSE
                            T.FIELD.NAME = Y.CURRENCY.3
                        END
                        IF Y.FIELD.NAME EQ "" THEN

                            Y.FIELD.NAME = FMT(T.FIELD.NAME,"22R")
                        END ELSE
                            IF T.FIELD.NAME NE "" THEN
                                Y.FIELD.NAME = Y.FIELD.NAME : @VM : FMT(T.FIELD.NAME,"48R")
                            END
                        END
                    END

                END
                Y.CCY.CNT += 1
            REPEAT

            RETURN

        CASE Y.FIELD.NAME EQ 'DIFFERENCE'
            Y.FIELD.NAME = ""
            Y.DIFFERENCE = R.NEW(TT.TID.DIFFERENCE)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @VM, @FM)
            Y.DIFFERENCE = CHANGE(Y.DIFFERENCE, @SM, @FM)

            Y.DIFF.CNT = 1
            Y.FOUND.CNT = 0
            LOOP
                REMOVE Y.DIFF FROM Y.DIFFERENCE SETTING DIFF.POS
            WHILE Y.DIFF:DIFF.POS
                T.FIELD.NAME = ""

                IF Y.DIFFERENCE<Y.DIFF.CNT> NE 0 THEN
                    T.FIELD.NAME  = Y.DIFFERENCE<Y.DIFF.CNT>

                    IF Y.FIELD.NAME EQ "" THEN
                        Y.FIELD.NAME = FMT(T.FIELD.NAME,"35R")
                    END ELSE
                        IF T.FIELD.NAME NE "" THEN
                            Y.FIELD.NAME = Y.FIELD.NAME : @VM : FMT(T.FIELD.NAME,"48R")
                        END
                    END

                END

                Y.DIFF.CNT += 1
            REPEAT

            RETURN
        CASE Y.FIELD.NAME EQ 'Y.OVERRIDE.1'
            GOSUB OVERRIDE1


            RETURN

        CASE Y.FIELD.NAME EQ 'Y.OVERRIDE.2'






            GOSUB OVERRIDE2

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.DATE.TIME'
            GET.DATE.TIME = R.NEW(TT.TID.DATE.TIME)
            GOSUB GET.DATE.TIME.INFO

            RETURN

    END CASE

    GOSUB SEND.PROCESS

RETURN
*-------------------------------------------------------------------------
SEND.PROCESS:
*-------------------------------------------------------------------------

    BEGIN CASE

        CASE Y.FIELD.NAME EQ 'Y.CO.CODE'
            Y.TELLER.NAME = R.NEW(TT.TID.USER)
            Y.TELLER.NAME=Y.TELLER.NAME[1,7]
            GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":Y.TELLER.NAME
            Y.FIELD.NAME = FMT(GET.CO.CODE,"30R")

            RETURN

        CASE Y.FIELD.NAME EQ 'Y.STMT.NO'
            Y.TELLER.ID2=ID.NEW
            FN.TELLER.ID = 'F.TELLER.ID'
            F.TELLER.ID = ''
            CALL OPF(FN.TELLER.ID,F.TELLER.ID)
            CALL F.READ(FN.TELLER.ID,Y.TELLER.ID2,R.TELLER.ID,F.TELLER.ID,I.ERR)
            Y.STMT.NO=R.TELLER.ID<TT.TID.STMT.NO>
            Y.STMT.NO= CHANGE(Y.STMT.NO,@SM,@VM)
            Y.STMT.NO= CHANGE(Y.STMT.NO,@FM,@VM)
            Y.STMT.NO= Y.STMT.NO<1,1>
            Y.STMT.NO=Y.STMT.NO[1,34]
            Y.FIELD.NAME  = FMT(Y.STMT.NO,"34R")

            RETURN


    END CASE

RETURN
*-----------------------------------------------
OVERRIDE2:
*-----------------------------------------------
    Y.OVERRIDE.2 = R.NEW(TT.TID.OVERRIDE)
    Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,@SM,@VM)
    Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,@FM,@VM)
    Y.OVERRIDE.2 = Y.OVERRIDE.2<1,2>
    Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,'{',@FM)
    Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,'}',@VM)
    CALL TXT(Y.OVERRIDE.2)
    Y.OVERRIDE.2 = Y.OVERRIDE.2[1,34]
    Y.FIELD.NAME  = FMT(Y.OVERRIDE.2,"34R")
RETURN

*-----------------------------------------------
OVERRIDE1:
*-----------------------------------------------

    Y.OVERRIDE.1 = R.NEW(TT.TID.OVERRIDE)
    Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,@SM,@VM)
    Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,@FM,@VM)
    Y.OVERRIDE.1 = Y.OVERRIDE.1<1,1>
    Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,'{',@FM)
    Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,'}',@VM)
    CALL TXT(Y.OVERRIDE.1)
    Y.OVERRIDE.1 = Y.OVERRIDE.1[1,34]
    Y.FIELD.NAME  = FMT(Y.OVERRIDE.1,"34R")
RETURN
*-----------------------------------------------
GET.DATE.TIME.INFO:
*-----------------------------------------------

    F1 = GET.DATE.TIME[1,2]
    F2 = GET.DATE.TIME[3,2]
    F3 = GET.DATE.TIME[5,2]
    F4 = GET.DATE.TIME[7,2]
    F5 = GET.DATE.TIME[9,2]

    Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
    Y.FIELD.NAME = FMT(Y.TIME,"15R")

RETURN


END
