$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>350</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.GET.PASSWORD(Y.DATA,RESPONSE.PARAM)
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    USER="ARCUSER"


	LOGIN = TRIM(FIELDS(Y.DATA,"*",1))
    PASSWORD = TRIM(FIELDS(Y.DATA,"*",2))

	FOR I = 3 TO DCOUNT(Y.DATA,'*')
		PASSWORD := '*' : TRIM(FIELDS(Y.DATA,"*",I))
    NEXT I
 
    FN.FILE = "F.ITSS.IBSOLUTION.USER"
    F.FILE = ""
    CALL OPF(FN.FILE,F.FILE)

    Y.ERROR = "NO"

    READ R.CONCAT FROM F.FILE, LOGIN  ELSE
        Y.ERROR = "RECORD MISSING"
    END
    OLD.PASSWORD = R.CONCAT<4,1,1>

    Y1 = LEN(USER) ; Y2 = Y1 ; Y3 = 0 ; SLP1 = '' ; SLP2 = ''
    FOR Y4 = 1 TO Y1
        Y5 = SEQX(USER[Y4,1]) ; Y2 := Y5 ; Y3 += Y5
    NEXT Y4
    Y2 = Y3:Y2 ; Y1 = LEN(PASSWORD) ; Y4 = "" ; Y5 = Y2[1,3]
    FOR Y3 = 1 TO Y1
        Y5 += SEQX(PASSWORD[Y3,1])
        IF MOD(Y3,2) THEN Y5 += Y2[1,2]-Y3 ELSE Y5 -= Y2[1,2]+Y3
        Y2 = Y2[3,999]:Y2[1,2] ; YCORR.CHAR = 0 ; YLOOP = 0 ; YLOOP2 = 0
        LOOP
            BEGIN CASE
                CASE Y5 > 176 AND Y5 < 186 ; YCORR.CHAR = 1
                CASE Y5 > 192 AND Y5 < 219 ; YCORR.CHAR = 1
                CASE Y5 > 224 AND Y5 < 248 ; YCORR.CHAR = 1     ;*CI_10042465 S/E
                CASE YLOOP = 20 ; YLOOP += Y5 ; YCORR.CHAR = 1 ; Y5 = 216
                CASE 1 ; YLOOP += 1 ; Y5 += 7*Y3 ; IF Y5 > 255 THEN Y5 -= 128 ; YLOOP2 += 1
            END CASE
        UNTIL YCORR.CHAR REPEAT
        Y4 := CHARX(Y5) ; SLP1 := YLOOP:@VM ; SLP2 := YLOOP2:@VM
    NEXT Y3
    PASSWORD = Y4 ;
*DEBUG
*    PRINT PASSWORD : " " : OLD.PASSWORD
    IF PASSWORD EQ OLD.PASSWORD THEN
        RESPONSE.PARAM = "OK"
    END
    ELSE
        RESPONSE.PARAM = Y.ERROR
    END

RETURN
