* @ValidationCode : MjotMTM4NTQ2MDg0OTpDcDEyNTI6MTY4MTIwMTA1MzA0NTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 13:47:33
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.L.NCF.STOCK.VALIDATE
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.L.NCF.STOCK.VALIDATE
* ODR NUMBER    : ODR-2009-12-0282
*-------------------------------------------------------------------------

* Description : This Routine is used to format the Field values of fields BUSINESS.DIV
*               PECF,AICF,TCF to their required length

* In parameter : None
* out parameter : None
*MODIFICATION HISTORY
*------------------------------------------------------------------------------
*DATE            WHO                REFERENCE                   DESCRIPTION
*30-06-2011      Riyas              PACS00075394                CHANG IF CONDITION
*29-03-2018      Gopala Krishnan R  PACS00660192                BUSINESS.DIV, PECF and AICF allow to be blank.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, ++ TO +=,> TO GT
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.L.NCF.STOCK
    $INSERT I_GTS.COMMON

    GOSUB PROCESS
    GOSUB PREV.INPUT
    GOSUB CHECK.AVAIL

RETURN
********
PROCESS:
********
* This is used to format the values for the fields in Template REDO.L.NCF.STOCk

    VAR.BUSINESS.DIV=R.NEW(ST.BUSINESS.DIV)
    VAR.PECF         =R.NEW(ST.PECF)
    VAR.AICF         =R.NEW(ST.AICF)
    VAR.TCF          =R.NEW(ST.TCF)
* PACS00660192 - S
    IF R.NEW(ST.BUSINESS.DIV) THEN
        R.NEW(ST.BUSINESS.DIV)=FMT(VAR.BUSINESS.DIV,'R%2')
    END ELSE
        R.NEW(ST.BUSINESS.DIV)= VAR.BUSINESS.DIV
    END

    IF R.NEW(ST.PECF) THEN
        R.NEW(ST.PECF)        =FMT(VAR.PECF,'R%3')
    END ELSE
        R.NEW(ST.PECF)        = VAR.PECF
    END

    IF R.NEW(ST.AICF) THEN
        R.NEW(ST.AICF)        =FMT(VAR.AICF,'R%3')
    END ELSE
        R.NEW(ST.AICF)        = VAR.AICF
    END
* PACS00660192 - E
    R.NEW(ST.TCF)         =FMT(VAR.TCF,'R%2')

    VAR.ST.RG             =R.NEW(ST.L.STRT.RNGE.ORG)
    VAR.ST.RG.DR          =R.NEW(ST.L.ST.RG.DR.NOTE)
    VAR.ST.RG.CR          =R.NEW(ST.L.ST.RG.CR.NOTE)

    VAR.SEQ               =R.NEW(ST.SEQUENCE.NO)
    VAR.QTY.AVAIL.ORG     =R.NEW(ST.QTY.AVAIL.ORG)

    VAR.SEQ.DR            =R.NEW(ST.SEQUENCE.DR)
    VAR.QTY.AVAIL.DR      =R.NEW(ST.L.QTY.AVAIL.DR)

    VAR.SEQ.CR            = R.NEW(ST.SEQUENCE.CR)
    VAR.QTY.AVAIL.CR      = R.NEW(ST.L.QTY.AVAIL.CR)


RETURN
***********
PREV.INPUT:
***********

    IF R.OLD(ST.L.STRT.RNGE.ORG) NE R.NEW(ST.L.STRT.RNGE.ORG) OR R.OLD(ST.L.END.RNGE.ORG) NE R.NEW(ST.L.END.RNGE.ORG) THEN
        IF R.NEW(ST.L.STRT.RNGE.ORG) GE R.NEW(ST.L.END.RNGE.ORG) THEN
            AF=ST.L.END.RNGE.ORG
            ETEXT='EB-CHECK-RANGE'
            CALL STORE.END.ERROR
        END
        IF VAR.SEQ EQ '' OR NOT(VAR.QTY.AVAIL.ORG) THEN
            R.NEW(ST.SEQUENCE.NO) = FMT(VAR.ST.RG,'R%8')
        END
        IF R.OLD(ST.L.STRT.RNGE.ORG) NE '' THEN
            VAR.PREV.START= R.OLD(ST.PRE.ST.RG.OR)
            VAR.PREV.RG.COUNT=DCOUNT(VAR.PREV.START,@VM)
            R.NEW(ST.PRE.ST.RG.OR)<1,VAR.PREV.RG.COUNT+1>=R.OLD(ST.L.STRT.RNGE.ORG)
            R.NEW(ST.PRE.ED.RG.OR)<1,VAR.PREV.RG.COUNT+1>=R.OLD(ST.L.END.RNGE.ORG)
        END
        VAR.NEW.ALLOT=R.NEW(ST.L.END.RNGE.ORG)-R.NEW(ST.L.STRT.RNGE.ORG)+1
        R.NEW(ST.NCF.HELD.ORG)=R.OLD(ST.NCF.HELD.ORG)+VAR.NEW.ALLOT
        R.NEW(ST.QTY.AVAIL.ORG)=R.OLD(ST.QTY.AVAIL.ORG)+VAR.NEW.ALLOT
        GOSUB RANGE.VALIDATION.OR
    END

    IF R.OLD(ST.L.ST.RG.DR.NOTE) NE R.NEW(ST.L.ST.RG.DR.NOTE) OR R.OLD(ST.L.ED.RG.DR.NOTE) NE R.NEW(ST.L.ED.RG.DR.NOTE) THEN
        IF R.NEW(ST.L.ST.RG.DR.NOTE) GE R.NEW(ST.L.ED.RG.DR.NOTE) THEN
            AF=ST.L.ED.RG.DR.NOTE
            ETEXT='EB-CHECK-RANGE'
            CALL STORE.END.ERROR
        END
        IF VAR.SEQ.DR EQ '' OR NOT(VAR.QTY.AVAIL.DR) THEN
            R.NEW(ST.SEQUENCE.DR) = FMT(VAR.ST.RG.DR,'R%8')
        END
        IF R.OLD(ST.L.ST.RG.DR.NOTE) NE '' THEN
            VAR.PREV.START.DR= R.OLD(ST.PRE.ST.RG.DR)
            VAR.PREV.RG.COUNT.DR=DCOUNT(VAR.PREV.START.DR,@VM)
            R.NEW(ST.PRE.ST.RG.DR)<1,VAR.PREV.RG.COUNT.DR+1>=R.OLD(ST.L.ST.RG.DR.NOTE)
            R.NEW(ST.PRE.ED.RG.DR)<1,VAR.PREV.RG.COUNT.DR+1>=R.OLD(ST.L.ED.RG.DR.NOTE)
        END
        VAR.NEW.ALLOT.DR=R.NEW(ST.L.ED.RG.DR.NOTE)-R.NEW(ST.L.ST.RG.DR.NOTE)+1
        R.NEW(ST.L.NCF.HELD.DR)=R.OLD(ST.L.NCF.HELD.DR)+ VAR.NEW.ALLOT.DR
        R.NEW(ST.L.QTY.AVAIL.DR)=R.OLD(ST.L.QTY.AVAIL.DR)+ VAR.NEW.ALLOT.DR
        GOSUB RANGE.VALIDATION.DR
    END
    IF R.OLD(ST.L.ST.RG.CR.NOTE) NE R.NEW(ST.L.ST.RG.CR.NOTE) OR R.OLD(ST.L.ED.RG.CR.NOTE) NE R.NEW(ST.L.ED.RG.CR.NOTE) THEN
        IF R.NEW(ST.L.ST.RG.CR.NOTE) GE R.NEW(ST.L.ED.RG.CR.NOTE) THEN
            AF=ST.L.ED.RG.CR.NOTE
            ETEXT='EB-CHECK-RANGE'
            CALL STORE.END.ERROR
        END

        IF VAR.SEQ.CR EQ '' OR NOT(VAR.QTY.AVAIL.CR) THEN
            R.NEW(ST.SEQUENCE.CR)=  FMT(VAR.ST.RG.CR,'R%8')
        END
        IF R.OLD(ST.L.ST.RG.CR.NOTE) NE '' THEN
            VAR.PREV.START.CR= R.OLD(ST.PRE.ST.RG.CR)
            VAR.PREV.RG.COUNT.CR=DCOUNT(VAR.PREV.START.CR,@VM)
            R.NEW(ST.PRE.ST.RG.CR)<1,VAR.PREV.RG.COUNT.CR+1>=R.OLD(ST.L.ST.RG.CR.NOTE)
            R.NEW(ST.PRE.ED.RG.CR)<1,VAR.PREV.RG.COUNT.CR+1>=R.OLD(ST.L.ED.RG.CR.NOTE)
        END
        VAR.NEW.ALLOT.CR=R.NEW(ST.L.ED.RG.CR.NOTE)-R.NEW(ST.L.ST.RG.CR.NOTE)+1
        R.NEW(ST.L.NCF.HELD.CR)=R.OLD(ST.L.NCF.HELD.CR)+ VAR.NEW.ALLOT.CR
        R.NEW(ST.L.QTY.AVAIL.CR)=R.OLD(ST.L.QTY.AVAIL.CR)+ VAR.NEW.ALLOT.CR
        GOSUB RANGE.VALIDATION.CR
    END
RETURN

***********
CHECK.AVAIL:
************
    IF R.NEW(ST.QTY.AVAIL.ORG) GT R.NEW(ST.L.MIN.NCF.ORG) THEN ;*AUTO R22 CODE CONVERSION
        R.NEW(ST.NCF.STATUS.ORG)='AVAILABLE'
    END

    IF R.NEW(ST.L.QTY.AVAIL.DR) GT R.NEW(ST.MN.NCF.DR.NOTE) THEN ;*AUTO R22 CODE CONVERSION
        R.NEW(ST.NCF.STATUS.DR)='AVAILABLE'
    END

    IF R.NEW(ST.L.QTY.AVAIL.CR) GT R.NEW(ST.MN.NCF.CR.NOTE) THEN ;*AUTO R22 CODE CONVERSION
        R.NEW(ST.NCF.STATUS.CR)='AVAILABLE'
    END
RETURN
********************
RANGE.VALIDATION.OR:
********************

    Y.PREV.START.OR    = R.NEW(ST.PRE.ST.RG.OR)
    Y.PREV.END.OR      = R.NEW(ST.PRE.ED.RG.OR)
    Y.PREV.RG.COUNT.OR = DCOUNT(Y.PREV.START.OR,@VM)


    IF Y.PREV.RG.COUNT.OR GE 1 THEN
        PREV.CNT = 1
        LOOP
        WHILE PREV.CNT LE Y.PREV.RG.COUNT.OR
            IF R.NEW(ST.L.STRT.RNGE.ORG) GT Y.PREV.END.OR<1,Y.PREV.RG.COUNT.OR> AND R.NEW(ST.L.END.RNGE.ORG) GT Y.PREV.END.OR<1,Y.PREV.RG.COUNT.OR> THEN
                IF VAR.SEQ GE Y.PREV.START.OR<1,Y.PREV.RG.COUNT.OR> THEN
                END ELSE
                    AF=ST.L.END.RNGE.ORG
                    ETEXT='EB-CHECK-RANGE'
                    CALL STORE.END.ERROR
                END

            END ELSE
                AF=ST.L.END.RNGE.ORG
                ETEXT='EB-CHECK-RANGE'
                CALL STORE.END.ERROR
            END
            PREV.CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

RETURN
********************
RANGE.VALIDATION.DR:
********************
    Y.PREV.START.DR= R.NEW(ST.PRE.ST.RG.DR)
    Y.PREV.END.DR  = R.NEW(ST.PRE.ED.RG.DR)
    Y.PREV.RG.COUNT.DR=DCOUNT(Y.PREV.START.DR,@VM)

    IF Y.PREV.RG.COUNT.DR GE 1 THEN
        PREV.CNT = 1
        LOOP
        WHILE PREV.CNT LE Y.PREV.RG.COUNT.DR
            IF R.NEW(ST.L.ST.RG.DR.NOTE) GT Y.PREV.END.DR<1,Y.PREV.RG.COUNT.DR> AND R.NEW(ST.L.ED.RG.DR.NOTE) GT Y.PREV.END.DR<1,Y.PREV.RG.COUNT.DR> THEN

                IF VAR.SEQ.DR GE Y.PREV.START.DR<1,Y.PREV.RG.COUNT.DR> THEN
                END ELSE
                    AF=ST.L.END.RNGE.ORG
                    ETEXT='EB-CHECK-RANGE'
                    CALL STORE.END.ERROR
                END
            END ELSE
                AF=ST.L.END.RNGE.ORG
                ETEXT='EB-CHECK-RANGE'
                CALL STORE.END.ERROR
            END
            PREV.CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END
RETURN
********************
RANGE.VALIDATION.CR:
********************
    Y.PREV.START.CR    = R.NEW(ST.PRE.ST.RG.CR)
    Y.PREV.END.CR      = R.NEW(ST.PRE.ED.RG.CR)
    Y.PREV.RG.COUNT.CR = DCOUNT(Y.PREV.START.CR,@VM)

    IF Y.PREV.RG.COUNT.CR GE 1 THEN
        PREV.CNT = 1
        LOOP
        WHILE PREV.CNT LE Y.PREV.RG.COUNT.CR
            IF R.NEW(ST.L.ST.RG.CR.NOTE) GT Y.PREV.END.CR<1,Y.PREV.RG.COUNT.CR> AND R.NEW(ST.L.ED.RG.CR.NOTE) GT Y.PREV.END.CR<1,Y.PREV.RG.COUNT.CR> THEN
                IF VAR.SEQ.CR GE Y.PREV.START.CR<1,Y.PREV.RG.COUNT.CR> THEN
                END ELSE
                    AF=ST.L.END.RNGE.ORG
                    ETEXT='EB-CHECK-RANGE'
                    CALL STORE.END.ERROR
                END
            END ELSE
                AF=ST.L.END.RNGE.ORG
                ETEXT='EB-CHECK-RANGE'
                CALL STORE.END.ERROR
            END
            PREV.CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END
RETURN
END
