* @ValidationCode : MjotMTA0NzA0NTkwMzpDcDEyNTI6MTcwMzU4NTczOTgxMjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 15:45:39
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EMAIL.EXP.LIMIT.LOAD
*-----------------------------------------------------------------------------
* Company Name  : APAP
* Developed By  : Balagurunathan
*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* PACS00242938        23-Jan-2013           Cob job to raise email
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - VM TO @VM
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    IDVAR, FNVAR Variable Changed
*-----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.USER.LIMITS
    $INSERT I_REDO.B.EMAIL.EXP.LIMIT.COMMON
    $INSERT I_F.REDO.MM.CUST.LIMIT
    $INSERT I_F.INTERFACE.CONFIG.PRT
    $INSERT I_F.REDO.ISSUE.EMAIL
    
   

    FN.REDO.APAP.FX.BRN.COND='F.REDO.APAP.FX.BRN.COND'
    F.REDO.APAP.FX.BRN.COND=''
    CALL OPF(FN.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND)

    F.REDO.APAP.FX.BRN.POSN=''
    FN.REDO.APAP.FX.BRN.POSN='F.REDO.APAP.FX.BRN.POSN'
    CALL OPF(FN.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN)

    FN.REDO.APAP.USER.LIMITS='F.REDO.APAP.USER.LIMITS'
    F.REDO.APAP.USER.LIMITS=''
    CALL OPF (FN.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.LIMIT='F.LIMIT'
    F.LIMIT=''
    CALL OPF(FN.LIMIT,F.LIMIT)

    F.REDO.MM.CUST.LIMIT=''
    FN.REDO.MM.CUST.LIMIT='F.REDO.MM.CUST.LIMIT'
    CALL OPF(FN.REDO.MM.CUST.LIMIT,F.REDO.MM.CUST.LIMIT)


*  CALL F.READ(FN.REDO.APAP.FX.BRN.COND,'SYSTEM',R.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND,ERR)          ;*CACHE.READ is not used as the value in record will get changed and updated. ;*Tus Start
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*    CALL CACHE.READ(FN.REDO.APAP.FX.BRN.COND,'SYSTEM',R.REDO.APAP.FX.BRN.COND,ERR)
    CALL CACHE.READ(FN.REDO.APAP.FX.BRN.COND,IDVAR,R.REDO.APAP.FX.BRN.COND,ERR) ;*R22 Manual Conversion
    NO.DAYS=R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.VERIFY.EXP>
    TOD.DATE=TODAY

    IF NO.DAYS NE '' THEN
        CALL CDT('',TOD.DATE,'+':NO.DAYS:'C')
    END

    Y.MAIL.SUBJECT=R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.EXP.EMAIL>
    Y.MAIL.BODY=R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.EXP.BODY>

    CHANGE @VM TO ' ' IN Y.MAIL.SUBJECT
    CHANGE @VM TO ' ' IN Y.MAIL.BODY



    FN.REDO.ISSUE.EMAIL='F.REDO.ISSUE.EMAIL' ;*R22 Manual Conversion
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*   CALL CACHE.READ(FN.REDO.ISSUE.EMAIL,'SYSTEM',R.REDO.ISSUE.EMAIL,MAIL.ERR)
    CALL CACHE.READ(FN.REDO.ISSUE.EMAIL,IDVAR,R.REDO.ISSUE.EMAIL,MAIL.ERR) ;*R22 Manual Conversion
    
    BK.MAIL.ID    = R.REDO.ISSUE.EMAIL<ISS.ML.MAIL.ID>
    Y.FROM.MAIL   = BK.MAIL.ID
    
    FN.INTERFACE.CONFIG.PRT='F.INTERFACE.CONFIG.PRT' ;*R22 Manual Conversion
    IDVAR='email' ;*R22 Manual Conversion
*   CALL CACHE.READ('F.INTERFACE.CONFIG.PRT','email',R.INTERFACE.CONFIG.PRT,ERR)
    CALL CACHE.READ('F.INTERFACE.CONFIG.PRT',IDVAR,R.INTERFACE.CONFIG.PRT,ERR) ;*R22 Manual Conversion
    
    Y.FIELD=R.INTERFACE.CONFIG.PRT<INTRF.MSG.INT.FLD.NAME>
    Y.FLD.VAL=R.INTERFACE.CONFIG.PRT<INTRF.MSG.INT.FLD.VAL>

    LOCATE 'EMAIL_FOLDER_PATH' IN Y.FIELD<1,1> SETTING POS.FLD THEN

        Y.FILE.PATH=Y.FLD.VAL<1,POS.FLD>
    END



    FN.HRMS.FILE        = Y.FILE.PATH
    F.HRMA.FILE         = ""


    CALL OPF(FN.HRMS.FILE,F.HRMA.FILE)



RETURN

END
