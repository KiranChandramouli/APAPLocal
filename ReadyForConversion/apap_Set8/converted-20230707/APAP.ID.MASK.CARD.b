SUBROUTINE APAP.ID.MASK.CARD
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.APAP.PARAM.DB.CR.MASK

*Desc: To update the MASKED value for the debit/credit card which will be replaced by original calues again in Authorisation routine
*Linked to : Version control routine - AUTH routine TEST.AUTH.VAL
*By : Nishant Yadav
*Date : 20180313

    IF V$FUNCTION EQ "S" OR V$FUNCTION EQ "A" THEN
        GOSUB INIT
        GOSUB PROCESS
    END


RETURN
*-------------------------------------------------------------------------------
INIT:
    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK" ;    F.APAP.PARAM.DB.CR.MASK = "" ; CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)
    FN.APP = "F.":APPLICATION ; F.APP = "" ; CALL OPF(FN.APP,F.APP)
    FN.APP.NAU = "F.":APPLICATION:"$NAU":@FM:'NO.FATAL.ERROR' ; F.APP.NAU = "" ; CALL OPF(FN.APP.NAU,F.APP.NAU)

    IF ETEXT THEN

        NAU.NOT.EXIST=1

    END

    FN.APP.HIS = "F.":APPLICATION:"$HIS":@FM:'NO.FATAL.ERROR' ; F.APP.HIS = "" ; CALL OPF(FN.APP.HIS,F.APP.HIS)

    IF ETEXT THEN

        HIS.NOT.EXIST=1

    END

    Y.VER.NAME = APPLICATION:PGM.VERSION

RETURN
*------------------------------------------------------------------------------------
PROCESS:

    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,Y.VER.NAME,R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
    IF R.MASK.PARAM THEN
        Y.VER.FLD.LST = R.MASK.PARAM<APAP.MASK.VER.FLD.ENQ.COL>
        CHANGE @VM TO @FM IN Y.VER.FLD.LST

* Looping if multiple fields are indicated to be masked in param table APAP.PARAM.DB.CR.MASK
        LOOP
            REMOVE Y.VER.FLD FROM Y.VER.FLD.LST SETTING Y.POS.VER.FLD.LIST
        WHILE Y.VER.FLD:Y.POS.VER.FLD.LIST
            CALL GET.STANDARD.SELECTION.DETS(APPLICATION,R.SS)
            IF R.SS THEN
                Y.FIELD.NAMES = R.SS<SSL.SYS.FIELD.NAME>
                LOCATE Y.VER.FLD IN Y.FIELD.NAMES<1,1> SETTING Y.POS.SS.FIELD THEN
                    Y.SS.FIELD.POS = R.SS<SSL.SYS.FIELD.NO,Y.POS.SS.FIELD>

                    IF NOT(NAU.NOT.EXIST) THEN
                        R.APP.NAU = ""
                        CALL F.READ(FN.APP.NAU,COMI,R.APP.NAU,F.APP.NAU,ERR.APP.NAU)
                        IF R.APP.NAU THEN
                            Y.CARD.NUM.LST = R.APP.NAU<Y.SS.FIELD.POS>  ; Y.CARD.NUM.LST.BKP = R.APP.NAU<Y.SS.FIELD.POS>
                            Y.CARDS<-1> = Y.VER.FLD:"*":Y.CARD.NUM.LST.BKP

                            IF Y.CARD.NUM.LST EQ ''   THEN


                                IF  APPLICATION EQ 'AC.LOCKED.EVENTS' THEN

                                    CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                    Y.CARD.NUM.LST =  R.APP.NAU<AC.LCK.LOCAL.REF,POSLOC>
                                    Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                    GOSUB CHECK.MULTI.SET
                                    GOSUB MASK.CARD.NUM
                                    R.APP.NAU<AC.LCK.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                    CALL F.WRITE(FN.APP.NAU,COMI,R.APP.NAU)

                                END

                                IF  APPLICATION EQ 'FUNDS.TRANSFER' THEN

                                    CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                    Y.CARD.NUM.LST =  R.APP.NAU<FT.LOCAL.REF,POSLOC>
                                    Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                    GOSUB CHECK.MULTI.SET
                                    GOSUB MASK.CARD.NUM
                                    R.APP.NAU<FT.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                    CALL F.WRITE(FN.APP.NAU,COMI,R.APP.NAU)

                                END


                            END ELSE

                                GOSUB CHECK.MULTI.SET
                                GOSUB MASK.CARD.NUM
                                R.APP.NAU<Y.SS.FIELD.POS> = Y.MASK.CARD.FIN
                                CALL F.WRITE(FN.APP.NAU,COMI,R.APP.NAU)
                            END

                        END
                    END

                    IF NOT(HIS.NOT.EXIST) THEN

                        VAR.HIS = COMI

                        CALL F.READ.HISTORY(FN.APP.HIS,VAR.HIS,R.ACC.HIS,F.APP.HIS, AC.HIS.ERR )

                        R.APP.HIS = ""

                        CALL F.READ(FN.APP.HIS,VAR.HIS,R.APP.HIS,F.APP.HIS,ERR.APP.HIS)

                        IF R.APP.HIS THEN
                            Y.CARD.NUM.LST = R.APP.HIS<Y.SS.FIELD.POS>
                            Y.CARD.NUM.LST.BKP = R.APP.HIS<Y.SS.FIELD.POS>
                            Y.CARDS<-1> = Y.VER.FLD:"*":Y.CARD.NUM.LST.BKP

                            IF Y.CARD.NUM.LST EQ ''   THEN

                                IF APPLICATION EQ 'AC.LOCKED.EVENTS' THEN

                                    CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                    Y.CARD.NUM.LST =  R.APP.HIS<AC.LCK.LOCAL.REF,POSLOC>
                                    Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                    GOSUB CHECK.MULTI.SET
                                    GOSUB MASK.CARD.NUM
                                    R.APP.HIS<AC.LCK.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                    CALL F.WRITE(FN.APP.HIS,VAR.HIS,R.APP.HIS)

                                END

                                IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

                                    CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                    Y.CARD.NUM.LST =  R.APP.HIS<FT.LOCAL.REF,POSLOC>
                                    Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                    GOSUB CHECK.MULTI.SET
                                    GOSUB MASK.CARD.NUM
                                    R.APP.HIS<FT.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                    CALL F.WRITE(FN.APP.HIS,VAR.HIS,R.APP.HIS)
                                END


                            END ELSE

                                GOSUB CHECK.MULTI.SET
                                GOSUB MASK.CARD.NUM
                                R.APP.HIS<Y.SS.FIELD.POS> = Y.MASK.CARD.FIN
                                CALL F.WRITE(FN.APP.HIS,VAR.HIS,R.APP.HIS)
                            END

                        END
                    END

                    IF NOT(HIS.NOT.EXIST) THEN

                        VAR.HIS = COMI :';':V$DISPLAY

                        R.APP.HIS = ""
                        CALL F.READ(FN.APP.HIS,VAR.HIS,R.APP.HIS,F.APP.HIS,ERR.APP.HIS)

                        IF R.APP.HIS THEN
                            Y.CARD.NUM.LST = R.APP.HIS<Y.SS.FIELD.POS>
                            Y.CARD.NUM.LST.BKP = R.APP.HIS<Y.SS.FIELD.POS>
                            Y.CARDS<-1> = Y.VER.FLD:"*":Y.CARD.NUM.LST.BKP

                            IF Y.CARD.NUM.LST EQ '' THEN

                                IF APPLICATION EQ 'AC.LOCKED.EVENTS' THEN

                                    CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                    Y.CARD.NUM.LST =  R.APP.HIS<AC.LCK.LOCAL.REF,POSLOC>
                                    Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                    GOSUB CHECK.MULTI.SET
                                    GOSUB MASK.CARD.NUM
                                    R.APP.HIS<AC.LCK.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                    CALL F.WRITE(FN.APP.HIS,VAR.HIS,R.APP.HIS)

                                END

                                IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

                                    CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                    Y.CARD.NUM.LST =  R.APP.HIS<FT.LOCAL.REF,POSLOC>
                                    Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                    GOSUB CHECK.MULTI.SET
                                    GOSUB MASK.CARD.NUM
                                    R.APP.HIS<FT.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                    CALL F.WRITE(FN.APP.HIS,VAR.HIS,R.APP.HIS)
                                END



                            END ELSE

                                GOSUB CHECK.MULTI.SET
                                GOSUB MASK.CARD.NUM
                                R.APP.HIS<Y.SS.FIELD.POS> = Y.MASK.CARD.FIN
                                CALL F.WRITE(FN.APP.HIS,VAR.HIS,R.APP.HIS)
                            END



                        END
                    END


                    R.APP = ""
                    CALL F.READ(FN.APP,COMI,R.APP,F.APP,ERR.APP)
                    IF R.APP THEN
                        Y.CARD.NUM.LST = R.APP<Y.SS.FIELD.POS>

                        IF Y.CARD.NUM.LST EQ ''  THEN

                            IF APPLICATION EQ 'AC.LOCKED.EVENTS' THEN

                                CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                Y.CARD.NUM.LST =  R.APP<AC.LCK.LOCAL.REF,POSLOC>
                                Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                GOSUB CHECK.MULTI.SET
                                GOSUB MASK.CARD.NUM
                                R.APP<AC.LCK.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                CALL F.WRITE(FN.APP,COMI,R.APP)

                            END


                            IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

                                CALL GET.LOC.REF(APPLICATION,Y.VER.FLD.LST,POSLOC);

                                Y.CARD.NUM.LST =  R.APP<FT.LOCAL.REF,POSLOC>
                                Y.CARD.NUM.AUTH = Y.CARD.NUM.LST[17,7]

                                GOSUB CHECK.MULTI.SET
                                GOSUB MASK.CARD.NUM
                                R.APP<FT.LOCAL.REF,POSLOC> = Y.MASK.CARD.FIN:Y.CARD.NUM.AUTH
                                CALL F.WRITE(FN.APP,COMI,R.APP)

                            END

                        END ELSE

                            GOSUB CHECK.MULTI.SET
                            GOSUB MASK.CARD.NUM
                            R.APP<Y.SS.FIELD.POS> = Y.MASK.CARD.FIN
                            CALL F.WRITE(FN.APP,COMI,R.APP)
                        END

                    END

                END
            END
        REPEAT
        CALL System.setVariable('CURRENT.CARD.LIST', Y.CARDS)
    END

RETURN
*---------------------------------------------------------------------
CHECK.MULTI.SET:

    Y.FM.LEN = "" ; Y.VM.CNT = "" ; Y.SM.CNT = "" ; Y.DEL = ""
    Y.FM.CNT = DCOUNT(Y.CARD.NUM.LST,@FM) ; Y.VM.CNT = DCOUNT(Y.CARD.NUM.LST,@VM) ; Y.SM.CNT = DCOUNT(Y.CARD.NUM.LST,@SM)

    IF Y.SM.CNT GT 1 THEN
        Y.DEL = @SM
    END ELSE
        IF Y.VM.CNT GT 1 THEN
            Y.DEL = @VM
        END ELSE
            IF Y.FM.CNT GT 1 THEN
                Y.DEL = "FM"
            END ELSE
                Y.DEL = "NA"
            END
        END
    END

RETURN
*---------------------------------------------------------------------
MASK.CARD.NUM:

    CHANGE @VM TO @FM IN Y.CARD.NUM.LST
    CHANGE @SM TO @FM IN Y.CARD.NUM.LST
    Y.TOT.CARD = DCOUNT(Y.CARD.NUM.LST,@FM)

    FOR Y.INIT.CA = 1 TO Y.TOT.CARD
        Y.CARD.NUM = FIELD(Y.CARD.NUM.LST,@FM,Y.INIT.CA)
        Y.CARD.TYPE.VAL = Y.CARD.NUM[1,4]
        Y.CARD.TYPE = NUM(Y.CARD.TYPE.VAL)
        IF Y.CARD.TYPE "1" THEN         ;*Card number startes with number
            Y.CARD.NUM =Y.CARD.NUM[1,16]
        END ELSE    ;*Card number starts with its Type
            Y.CARD.NUM = Y.CARD.NUM[6,LEN(Y.CARD.NUM)]
        END
        GOSUB CHK.EXCEPTION

        IF Y.EXCEPTION.FLG EQ "0" THEN
            Y.INT = 1
            Y.LEN.CARD = LEN(Y.CARD.NUM)

            CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,Y.VER.NAME,R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
            IF R.MASK.PARAM THEN
                Y.PARAM.DIGIT = R.MASK.PARAM<APAP.MASK.MASKING.DIGITS>
                CHANGE " " TO @FM IN Y.PARAM.DIGIT
                LOOP
                WHILE Y.INT LE Y.LEN.CARD
                    Y.QUO = Y.INT/4
                    Y.QUO.DEC = FIELD(Y.QUO,".",2,1)
                    LOCATE Y.INT IN Y.PARAM.DIGIT SETTING Y.DIGI.POS THEN
                        IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                            Y.MASK.CA.NUM := "*"
                        END ELSE
                            Y.MASK.CA.NUM := "*-"
                        END
                    END ELSE
                        IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                            Y.MASK.CA.NUM := Y.CARD.NUM[Y.INT,1]
                        END ELSE
                            Y.MASK.CA.NUM := Y.CARD.NUM[Y.INT,1]:"-"
                        END
                    END
                    Y.INT += 1
                REPEAT
            END
        END ELSE    ;*THe flag to check if the card is exception. May be va
            Y.MASK.CA.NUM = Y.CARD.NUM
        END


        IF Y.CARD.TYPE "1" THEN
            Y.MASK.CARD = Y.MASK.CA.NUM
        END ELSE
            Y.MASK.CARD = Y.CARD.TYPE.VAL:".":Y.MASK.CA.NUM
        END
        Y.MASK.CA.NUM = ""
        GOSUB ARRANGE.MULTI.SET
    NEXT
*       REPEAT

    Y.MASK.CARD.FIN = Y.MASK.CARD.NUM
    Y.MASK.CARD.NUM = ""
    Y.MASK.CARD = ""

RETURN
*--------------------------------------------------------------
CHK.EXCEPTION:
    Y.EXCEPTION.FLG = 0


    IF LEN(Y.CARD.NUM) EQ "23" THEN

        Y.CARD.NUM = Y.CARD.NUM[1,16]

    END

    IF LEN(Y.CARD.NUM) NE "16" THEN
        Y.EXCEPTION.FLG = 1
    END

RETURN
*---------------------------------------------------------------
ARRANGE.MULTI.SET:
    BEGIN CASE
        CASE Y.DEL EQ @FM
            IF Y.INIT.CA NE "1" THEN
                Y.MASK.CARD.NUM := @FM:Y.MASK.CARD
            END ELSE
                Y.MASK.CARD.NUM = Y.MASK.CARD
            END

        CASE Y.DEL EQ @VM
            IF Y.INIT.CA NE "1" THEN
                Y.MASK.CARD.NUM := @VM:Y.MASK.CARD
            END ELSE
                Y.MASK.CARD.NUM = Y.MASK.CARD
            END

        CASE Y.DEL EQ @SM
            IF Y.INIT.CA NE "1" THEN
                Y.MASK.CARD.NUM := @SM:Y.MASK.CARD
            END ELSE
                Y.MASK.CARD.NUM = Y.MASK.CARD
            END

        CASE Y.DEL EQ "NA"
            Y.MASK.CARD.NUM = Y.MASK.CARD

    END CASE

RETURN

*-----------------------------------------------------------------------------

END
