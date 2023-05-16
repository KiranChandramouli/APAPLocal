$PACKAGE APAP.LAPAP
SUBROUTINE  L.APAP.MASK.DYN.OUT(Y.RESPONSE.VALUE, Y.FIELD.MASK.OUT, Y.ERROR)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - <= to LE , = to EQ , Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*Subroutine Masked T24 Field output field.
*----------------------------------------------------------------------------------------------------------------------------------------------------
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.MASK.DYN.OUT'
    Y.MASK = ''
    Y.CNT.MASK = ''
    Y.LEN =  ''
    Y.DGT = 0

    Y.MASK.CHR = ''

    CNT_VM = 0
    CNT_SM = 0

    CNT_SP = 0
    Y.REP.SP = ''

*DEBUG
    Y.MASK.TMP = Y.FIELD.MASK.OUT
    CHANGE ':' TO  @FM IN Y.MASK.TMP

    Y.MASK = TRIM(Y.MASK.TMP<1>, ' ', 'R')
    Y.MASK.CHR  = TRIM(Y.MASK.TMP<2>, ' ', 'R')
    IF Y.MASK.CHR  EQ  '' THEN
        Y.MASK.CHR  = 'X'
    END

    IF Y.MASK NE '' THEN

        CHANGE ' ' TO @FM IN Y.MASK

        Y.CNT.MASK  = DCOUNT(Y.MASK,@FM)
        FOR V.MASK = 1 TO Y.CNT.MASK  STEP 1
            Y.DGT = Y.MASK<V.MASK>
            IF ISDIGIT(Y.DGT ) THEN
                CNT_VM = DCOUNT(Y.RESPONSE.VALUE<1>,@VM)
                FOR V.J = 1 TO CNT_VM STEP 1
                    CNT_SM = DCOUNT(Y.RESPONSE.VALUE<1,V.J>,@SM)
                    FOR V.K = 1 TO CNT_SM STEP 1
                        CNT_SP = DCOUNT(Y.RESPONSE.VALUE<1,V.J,V.K>,' ')
                        IF CNT_SP EQ 1 THEN
                            Y.LEN = LEN(Y.RESPONSE.VALUE<1,V.J,V.K>)
                            IF  Y.DGT LE Y.LEN THEN
                                Y.RESPONSE.VALUE<1,V.J,V.K>[Y.DGT,1] = Y.MASK.CHR
                            END
                        END
                        ELSE
                            Y.REP.SP = Y.RESPONSE.VALUE<1,V.J,V.K>
                            CHANGE ' ' TO @FM IN Y.REP.SP

                            FOR V.SP = 1 TO CNT_SP STEP 1
                                Y.LEN = LEN(Y.REP.SP<V.SP>)
                                IF  Y.DGT LE Y.LEN THEN
                                    Y.REP.SP<V.SP>[Y.DGT,1] = Y.MASK.CHR
                                END
                            NEXT V.SP

                            CHANGE @FM TO ' ' IN  Y.REP.SP
                            Y.RESPONSE.VALUE<1,V.J,V.K> = Y.REP.SP
                        END
                    NEXT V.K
                NEXT V.J
            END
            ELSE
                Y.ERROR<1> = 1
                Y.ERROR<2> = 'INVALID MASK.OUT NON NUMERIC MASK AT OUTPUT MAPPING'
                RETURN
            END
        NEXT V.MASK

    END

RETURN
END
