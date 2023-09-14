* @ValidationCode : MjoxNDg1MTk4ODYyOkNwMTI1MjoxNjgxMjkzNTU0OTkwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:29:14
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
SUBROUTINE REDO.NCF.PERF.RTN(NCF.CNT,GET.NCF.ID)

*----------------------------------------------------------------------------------------------------------------------
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.NCF.PERF.RTN
*----------------------------------------------------------------------------------------------------------------------
* Description       : Routine to get the NCF for the transaction
* Linked With       : FT/TT
* In  Parameter     : NCF.CNT
* Out Parameter     : GET.NCF.ID
* Files  Used       : FT/TT
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                    Reference        Description
* ------       -----                  ------------     -------------
* 10-05-2015   Vignesh Kumaar M R     PACS00456843     NCF PERFORMANCE FIX
* 13-08-2018   Gopala Krishnan R      PACS00691027     Fix Modification
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM, ++ TO +=
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    FN.REDO.AA.NCF.IDS = 'F.REDO.AA.NCF.IDS'
    F.REDO.AA.NCF.IDS = ''
    CALL OPF(FN.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS)

    LOOP.CNT = NCF.CNT

    GET.NCF.ID = ''
    Y.REQ.FLAG = 0
    LOOP.INT = 1

    BEGIN CASE
        CASE OPERATOR EQ 'ARCUSER'
            GOSUB GET.NCF.ARCUSER

        CASE OTHERWISE
            GOSUB GET.NCF.TELLER.FT

    END CASE

    IF Y.REQ.FLAG NE 0 THEN
        Y.STANDBY.FLAG = ''
        GOSUB CALL.NCF.STANDBY
    END

RETURN

*---------------*
GET.NCF.ARCUSER:
*--------------*

    RAND.NUMBER=''  ;*PACS00691027
    BREAKOUT = 1    ;*PACS00691027

    LOOP
    WHILE GET.NCF.ID EQ '' AND BREAKOUT EQ 1      ;*PACS00691027
        Y.GET.RND = RND(50)
        GET.NCF.REC = 'ARCUSER.':Y.GET.RND
*PACS00691027-START
        LOCATE Y.GET.RND IN RAND.NUMBER<1,1> SETTING POS.LO ELSE
            RAND.NUMBER<1,-1>= Y.GET.RND
        END
        CON.VM=DCOUNT(RAND.NUMBER,@VM)
        IF CON.VM  GE 50 THEN
            BREAKOUT=0
        END

*PACS00691027-END

*    READU R.REDO.AA.NCF.IDS FROM F.REDO.AA.NCF.IDS, GET.NCF.REC LOCKED ;*Tus Start
        RETRY.VAR = "E"
        CALL F.READU(FN.REDO.AA.NCF.IDS,GET.NCF.REC,R.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS,R.REDO.AA.NCF.IDS.ERR,RETRY.VAR)
        IF R.REDO.AA.NCF.IDS.ERR EQ 'RECORD.LOCKED' THEN

            CONTINUE
        END ELSE
*  END THEN
            IF R.REDO.AA.NCF.IDS THEN   ;*Tus End
                LOOP
                WHILE LOOP.INT LE LOOP.CNT
                    IF R.REDO.AA.NCF.IDS<1> NE '' THEN
                        GET.NCF.ID <-1>= R.REDO.AA.NCF.IDS<1>
                        DEL R.REDO.AA.NCF.IDS<1>
                    END ELSE
                        Y.REQ.FLAG += 1 ;*AUTO R22 CODE CONVERSION
                    END
                    LOOP.INT += 1 ;*AUTO R22 CODE CONVERSION
                REPEAT
                GOSUB WRITE.NCF.CONCAT.TABLE
*PACS00691027-START
            END ELSE
                CALL F.RELEASE(FN.REDO.AA.NCF.IDS,GET.NCF.REC,F.REDO.AA.NCF.IDS)
            END
*PACS00691027-END


        END

    REPEAT

RETURN

*-----------------*
GET.NCF.TELLER.FT:
*-----------------*

    GET.NCF.REC = OPERATOR

*  READ R.REDO.AA.NCF.IDS FROM F.REDO.AA.NCF.IDS, GET.NCF.REC THEN ;*Tus Start
    CALL F.READ(FN.REDO.AA.NCF.IDS,GET.NCF.REC,R.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS,R.REDO.AA.NCF.IDS.ERR)
    IF R.REDO.AA.NCF.IDS THEN ;* Tus End

        LOOP
        WHILE LOOP.INT LE LOOP.CNT
            IF R.REDO.AA.NCF.IDS<LOOP.INT> NE '' THEN
                GET.NCF.ID <-1>= R.REDO.AA.NCF.IDS<1>
                DEL R.REDO.AA.NCF.IDS<1>
            END ELSE
                Y.REQ.FLAG += 1 ;*AUTO R22 CODE CONVERSION
            END
            LOOP.INT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
        GOSUB WRITE.NCF.CONCAT.TABLE
    END

    LOOP.INT = 1
    LOOP.CNT = NCF.CNT
    BREAKOUT = 1    ;*PACS00691027
    RAND.NUMBER=''  ;*PACS00691027
    IF GET.NCF.ID EQ '' THEN

        LOOP
        WHILE GET.NCF.ID EQ '' AND BREAKOUT EQ 1  ;*PACS00691027
            Y.GET.RND = RND(500)
            GET.NCF.REC = 'OTHERS.':Y.GET.RND
*PACS00691027-START
            LOCATE Y.GET.RND IN RAND.NUMBER<1,1> SETTING POS.LO ELSE
                RAND.NUMBER<1,-1>= Y.GET.RND
            END
            CON.VM=DCOUNT(RAND.NUMBER,@VM)
            IF CON.VM  GE 500 THEN

                BREAKOUT=0
            END

*PACS00691027-END

*      READU R.REDO.AA.NCF.IDS FROM F.REDO.AA.NCF.IDS, GET.NCF.REC LOCKED ;*Tus Start
            RETRY.VAR = "E"
            CALL F.READU(FN.REDO.AA.NCF.IDS,GET.NCF.REC,R.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS,R.REDO.AA.NCF.IDS.ERR,RETRY.VAR)
            IF R.REDO.AA.NCF.IDS.ERR EQ 'RECORD.LOCKED' THEN

                CONTINUE
            END ELSE
*    END THEN
                IF R.REDO.AA.NCF.IDS THEN         ;*Tus End
                    LOOP
                    WHILE LOOP.INT LE LOOP.CNT
                        IF R.REDO.AA.NCF.IDS<LOOP.INT> NE '' THEN
                            GET.NCF.ID <-1>= R.REDO.AA.NCF.IDS<1>
                            DEL R.REDO.AA.NCF.IDS<1>
                        END ELSE
                            Y.REQ.FLAG += 1 ;*AUTO R22 CODE CONVERSION
                        END
                        LOOP.INT += 1 ;*AUTO R22 CODE CONVERSION
                    REPEAT
                    GOSUB WRITE.NCF.CONCAT.TABLE
*PACS00691027-START
                END ELSE
                    CALL F.RELEASE(FN.REDO.AA.NCF.IDS,GET.NCF.REC,F.REDO.AA.NCF.IDS)
                END
*PACS00691027-END
            END
        REPEAT
    END
RETURN

*----------------*
CALL.NCF.STANDBY:
*----------------*

    BREAKOUT = 1    ;*PACS00691027
    RAND.NUMBER=''  ;*PACS00691027
    Y.INT.FLAG = 1
    LOOP
    WHILE Y.STANDBY.FLAG EQ '' AND BREAKOUT EQ 1  ;*PACS00691027
        Y.GET.RND = RND(50)
        GET.NCF.REC = 'OTHERS.':Y.GET.RND

*PACS00691027-START
        LOCATE Y.GET.RND IN RAND.NUMBER<1,1> SETTING POS.LO ELSE
            RAND.NUMBER<1,-1>= Y.GET.RND
        END
        CON.VM=DCOUNT(RAND.NUMBER,@VM)
        IF CON.VM  GE 50 THEN
            BREAKOUT=0
        END

*PACS00691027-END

*    READU R.REDO.AA.NCF.IDS FROM F.REDO.AA.NCF.IDS, GET.NCF.REC LOCKED ;*Tus Start
        RETRY.VAR = "E"
        CALL F.READU(FN.REDO.AA.NCF.IDS,GET.NCF.REC,R.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS,R.REDO.AA.NCF.IDS.ERR,RETRY.VAR)
        IF R.REDO.AA.NCF.IDS.ERR EQ 'RECORD.LOCKED' THEN

            CONTINUE
        END ELSE
*  END THEN
            IF R.REDO.AA.NCF.IDS THEN   ;*Tus End
                LOOP
                WHILE Y.INT.FLAG LE Y.REQ.FLAG
                    GET.NCF.ID <-1>= R.REDO.AA.NCF.IDS<1>
                    DEL R.REDO.AA.NCF.IDS<1>
                    Y.INT.FLAG += 1 ;*AUTO R22 CODE CONVERSION
                    Y.STANDBY.FLAG = 1
                REPEAT

                GOSUB WRITE.NCF.CONCAT.TABLE
*PACS00691027-START
            END ELSE
                CALL F.RELEASE(FN.REDO.AA.NCF.IDS,GET.NCF.REC,F.REDO.AA.NCF.IDS)
            END
*PACS00691027-END
        END
    REPEAT

RETURN

*----------------------*
WRITE.NCF.CONCAT.TABLE:
*----------------------*

    IF NOT(R.REDO.AA.NCF.IDS) THEN

*    DELETE F.REDO.AA.NCF.IDS, GET.NCF.REC ;*Tus Start
        CALL F.DELETE(FN.REDO.AA.NCF.IDS,GET.NCF.REC)       ;*Tus End
    END ELSE

*    WRITE R.REDO.AA.NCF.IDS TO F.REDO.AA.NCF.IDS, GET.NCF.REC ;*Tus Start
        CALL F.WRITE(FN.REDO.AA.NCF.IDS,GET.NCF.REC,R.REDO.AA.NCF.IDS)          ;*Tus End
    END
RETURN
