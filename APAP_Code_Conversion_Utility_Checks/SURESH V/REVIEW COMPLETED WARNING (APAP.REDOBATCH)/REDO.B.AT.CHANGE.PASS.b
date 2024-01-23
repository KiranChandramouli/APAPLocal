* @ValidationCode : MjotNzcyMzg0Mjk5OkNwMTI1MjoxNzAzMTM3NTI5MjQxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 11:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AT.CHANGE.PASS
*
* Subroutine Type : BATCH ROUTINE
* Attached to     : BATCH RECORD
* Attached as     : JOB ROUTINE
* Primary Purpose : Chance the user's password
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : September 07, 2010
* Date                   who                   Reference
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.INT AND ADDING END AND > TO GT AND > LT AND = TO EQ AND CONVERT TO CHANGE
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*20/12/2023         Suresh                R22 Manual Conversion   -IDVAR Variable changed
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT JBC.h

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*
*  Recupera todos los registros de la tabla REDO.AT.USER.PARMS

*  CALL F.READ(FN.REDO.AT.USER.PARMS,'SYSTEM',R.REDO.AT.USER.PARMS,F.REDO.AT.USER.PARMS,"") ;*Tus Start
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*   CALL CACHE.READ(FN.REDO.AT.USER.PARMS,'SYSTEM',R.REDO.AT.USER.PARMS,"")
    CALL CACHE.READ(FN.REDO.AT.USER.PARMS,IDVAR,R.REDO.AT.USER.PARMS,"") ; * Tus End ;*R22 Manual Conversion
    POS = 1

    LOOP
        SIGNON.USUARIO = R.REDO.AT.USER.PARMS<1,POS>
    WHILE SIGNON.USUARIO
        ID.USUARIO = R.REDO.AT.USER.PARMS<2,POS>

*    READ R.USER.REC FROM F.TUSER, ID.USUARIO ELSE ER = 'READ ERROR' ;*Tus Start
        
        CALL CACHE.READ(FN.TUSER, ID.USUARIO, R.USER.REC, R.USER.REC.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.TUSER
        IF R.USER.REC.ERR THEN
            ER = 'READ ERROR'
        END ;*Tus End
        COMI = TODAY:'M0601'
        CALL CFQ
        Y.NFEC = COMI
        GOSUB CODIFICAR.PASS
        GOSUB CHANGE.PASS
        R.USER.REC<EB.USE.PASSWORD>= USER.PASS
* Se debe quitar los comentarios de la linea siguiente cuando la fecha del sistema
* sea igual a la fecha del servidor
*R.USER.REC<EB.USE.PASSWORD.VALIDITY> = Y.NFEC

*    WRITE R.USER.REC TO F.TUSER, ID.USUARIO ;*Tus Start
        CALL F.WRITE(FN.TUSER,ID.USUARIO,R.USER.REC) ;*Tus End
        POS += 1
    REPEAT

RETURN  ;* from PROCESS
*-----------------------------------------------------------------------------------
* <New Subroutines>
*=============
CHANGE.PASS:
*=============
    STRAUX = STRPASS
    R.REDO.AT.USER.PASS = ""
    MPASS = ENCRYPT(STRAUX ,CLAVE,JBASE_CRYPT_DES)
    R.REDO.AT.USER.PASS<-1> = MPASS:@VM:CLAVE


*  WRITE R.REDO.AT.USER.PASS TO F.REDO.AT.USER.PASS, SIGNON.USUARIO ;*Tus Start
    CALL F.WRITE(FN.REDO.AT.USER.PASS,SIGNON.USUARIO,R.REDO.AT.USER.PASS) ;*Tus End
    
    
RETURN

*------------------
CODIFICAR.PASS:
*------------------
    USER.PASS = STRPASS
    USER.NAME = ID.USUARIO
    Y1 = LEN(USER.NAME) ; Y2 = Y1 ; Y3 = 0 ; SLP1 = '' ; SLP2 = ''
    FOR Y4 = 1 TO Y1
        Y5 = SEQX(USER.NAME[Y4,1]) ; Y2 := Y5 ; Y3 += Y5
    NEXT Y4
    Y2 = Y3:Y2 ; Y1 = LEN(USER.PASS) ; Y4 = "" ; Y5 = Y2[1,3]
    FOR Y3 = 1 TO Y1
        Y5 += SEQX(USER.PASS[Y3,1])
        IF MOD(Y3,2) THEN
            Y5 += Y2[1,2]-Y3
        END ELSE
            Y5 -= Y2[1,2]+Y3
        END
        Y2 = Y2[3,999]:Y2[1,2] ; YCORR.CHAR = 0 ; YLOOP = 0 ; YLOOP2 = 0
        LOOP
            BEGIN CASE
                CASE Y5 GT 176 AND Y5 LT 186 ; YCORR.CHAR = 1
                CASE Y5 GT 192 AND Y5 LT 219 ; YCORR.CHAR = 1
                CASE Y5 GT 224 AND Y5 LT 251 ; YCORR.CHAR = 1
                CASE YLOOP EQ 20 ; YLOOP += Y5 ; YCORR.CHAR = 1 ; Y5 = 216
                CASE 1 ; YLOOP += 1 ; Y5 += 7*Y3 ; IF Y5 GT 255 THEN
                        Y5 -= 128 ; YLOOP2 += 1
                    END    ;*R22 AUTO CONVERSTION ADDING END AND > TO GT AND > LT AND = TO EQ
            END CASE
        UNTIL YCORR.CHAR REPEAT
        Y4 := CHARX(Y5) ; SLP1 := YLOOP:@VM ; SLP2 := YLOOP2:@VM
    NEXT Y3
    USER.PASS = Y4 ;
RETURN

RETURN

* </New Subroutines>
*-----------------------------------------------------------------------------------*
INITIALISE:
*=========
* Variables
    ID.CONCAT = 'SYSTEM'
    STRAUX=TIMESTAMP()
    CHANGE ',' TO '' IN STRAUX  ;*R22 AUTO CONVERSTION CONVERT TO CHANGE
    POSINICIAL= LEN(STRAUX) - 9
    STRPASS = STRAUX[POSINICIAL,6]
    CLAVE = RND(777)
    STRAUX = ''

* Punteros

    F.REDO.AT.USER.PARMS = ''
    FN.REDO.AT.USER.PARMS = 'F.REDO.AT.USER.PARMS'
    R.REDO.AT.USER.PARMS = ''

    F.REDO.AT.USER.PASS = ''
    FN.REDO.AT.USER.PASS = 'F.REDO.AT.USER.PASS'
    R.REDO.AT.USER.PASS = ''

    FN.TUSER = 'F.USER'
    F.TUSER = ''

    PROCESS.GOAHEAD = 1

RETURN  ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.REDO.AT.USER.PARMS,F.REDO.AT.USER.PARMS)
    CALL OPF(FN.TUSER,F.TUSER)
    CALL OPF(FN.REDO.AT.USER.PASS,F.REDO.AT.USER.PASS)

RETURN  ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*======================

RETURN  ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END
