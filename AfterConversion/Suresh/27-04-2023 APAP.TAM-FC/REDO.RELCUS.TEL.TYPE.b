* @ValidationCode : MjotMjAxMzkwNDI0NjpDcDEyNTI6MTY4MjQ5NjkwODgwNzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 13:45:08
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
SUBROUTINE REDO.RELCUS.TEL.TYPE(CUST.ID,VAR.TEL.TYPE,VAR.TEL.AREA,VAR.TEL.NUMBER,VAR.TEL.EXT,VAR.TEL.CONTACT)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is field format routine for pdf generation form of KYC
* Input/Output:
*--------------
* IN :CUSTOMER.ID
* OUT : EDUCATION.LEVEL
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 25-Nov-2009     B Renugadevi       ODR-2010-04-0425     Initial Creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*18-04-2023            Conversion Tool             R22 Auto Code conversion                 VM TO @VM,SM TO @SM,++ to +=1
*18-04-2023              Samaran T                R22 Manual Code conversion                 CALL routine format modified
*----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_F.REDO.TEL.TYPE
    GOSUB INIT
    GOSUB PROCESS
RETURN

******
INIT:
******

    CUS.ID         = CUST.ID

    TEL.TYPE       = ''
    TEL.TYPE.ID    = ''
    VAR.TEL.TYPE = '' ; VAR.TEL.AREA = '' ; VAR.TEL.NUMBER = ''  ; VAR.TEL.EXT= '' ; VAR.TEL.CONTACT = ''
    VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>

    FN.CUSTOMER    = 'F.CUSTOMER'
    F.CUSTOMER     = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    LREF.FIELD = 'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM:'L.CU.TEL.NO':@VM:'L.CU.TEL.EXT':@VM:'L.CU.TEL.P.CONT'
    CALL APAP.TAM.MULTI.GET.LOC.REF('CUSTOMER',LREF.FIELD,LREF.POS) ;*MANUAL R22 CODE CONVERSION

    TEL.TYPE.POS             = LREF.POS<1,1>
    L.CU.TEL.AREA.POS        = LREF.POS<1,2>
    L.CU.TEL.NO.POS          = LREF.POS<1,3>
    L.CU.TEL.EXT.POS         = LREF.POS<1,4>
    L.CU.TEL.P.CONT.POS      = LREF.POS<1,5>

    FN.TEL.TYPE    = 'F.REDO.TEL.TYPE'
    F.TEL.TYPE     = ''
    CALL OPF(FN.TEL.TYPE,F.TEL.TYPE)

RETURN
*********
PROCESS:
********
    START.UP.COUNT = 1
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        TEL.TYPE.ID         = R.CUSTOMER<EB.CUS.LOCAL.REF,TEL.TYPE.POS>
        VAL.TEL.AREA        = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TEL.AREA.POS>
        VAL.TEL.NO          = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TEL.NO.POS>
        VAL.TEL.EXT         = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TEL.EXT.POS>
        VAL.TEL.CONTACT     = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TEL.P.CONT.POS>
    END
    ID.CNT =  DCOUNT(TEL.TYPE.ID,@SM)
    LOOP
    WHILE START.UP.COUNT LE ID.CNT
        TEL.ID = TEL.TYPE.ID<1,1,START.UP.COUNT>
        CALL F.READ(FN.TEL.TYPE,TEL.ID,R.TEL.TYPE,F.TEL.TYPE,TEL.ERR)
        TEL.TYP.DESC = R.TEL.TYPE<REDO.DESCRIPTION,VAR.USER.LANG>
        IF NOT(TEL.TYP.DESC) THEN
            TEL.TYP.DESC = R.TEL.TYPE<REDO.DESCRIPTION,1>
        END
        VAR.TEL.TYPE<1,-1> = TEL.TYP.DESC
        VAR.TEL.AREA<1,-1> = VAL.TEL.AREA<1,1,START.UP.COUNT>
        VAR.TEL.NUMBER<1,-1> = VAL.TEL.NO<1,1,START.UP.COUNT>
        CHK.VAL.EXT = VAL.TEL.EXT<1,1,START.UP.COUNT>
        IF CHK.VAL.EXT THEN
            VAR.TEL.EXT<1,-1> = CHK.VAL.EXT
        END ELSE
            VAR.TEL.EXT<1,-1> = 'N/A'
        END
        VAR.TEL.CONTACT<1,-1>  = VAL.TEL.CONTACT<1,1,START.UP.COUNT>
        START.UP.COUNT += 1
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------
END
