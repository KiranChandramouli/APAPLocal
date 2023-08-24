* @ValidationCode : MjoxOTA5NTEwNjAwOkNwMTI1MjoxNjgyMzM1OTQzNDc3OklUU1M6LTE6LTE6LTExOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -11
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 INCLUDE TO INSERT
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
SUBROUTINE  L.APAP.TRANSL.INPUT.FIELD(Y.DYN.REQUEST.KEY, Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.OFS.TYPE, Y.ERROR)
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION
    $INSERT I_EQUATE ;* AUTO R22 CODE CONVERSION

*Subroutine to Translate External Field name to T24 Field name.
*----------------------------------------------------------------------------------------------------------------------------------------------------
*CLEAR OUTPUTS VARIABLES
    Y.ERROR= ''
    Y.ERROR<3> = 'L.APAP.TRANSL.INPUT.FIELD'
    Y.DYN.REQUEST.OFS.KEY = ''
    Y.DYN.REQUEST.OFS.TYPE = ''

    Y.DYN.REQUEST.KEY.TMP = Y.DYN.REQUEST.KEY
    Y.DYN.REQUEST.KEY = ''

    Y.KEY.NAME.OPER = ''
    Y.KEY.NAME  = ''

    Y.JS.HAS.ID.FIELD = 0
    Y.MP.HAS.ID.FIELD = 0
    Y.OBJECT.TYPE = Y.DYN.MAPPING.IN<3>

*DEBUG

*CHECK IF MAPPING CONTAIN THE ID FIELD TO FILL FLAG
    Y.KEY.NAME = 'ID'
    LOCATE Y.KEY.NAME IN Y.DYN.MAPPING.IN<5,1> SETTING Y.POS THEN
        Y.MP.HAS.ID.FIELD = 1
    END
    Y.KEY.NAME = '@ID'
    LOCATE Y.KEY.NAME IN Y.DYN.MAPPING.IN<5,1> SETTING Y.POS THEN
        Y.MP.HAS.ID.FIELD = 2
    END

    Y.KEY.NAME = ''

    Y.KEY.CNT = DCOUNT(Y.DYN.REQUEST.KEY.TMP, @FM)
    FOR V.I = 1 TO Y.KEY.CNT  STEP 1
        Y.KEY.NAME.OPER = Y.DYN.REQUEST.KEY.TMP<V.I>
        CHANGE ':' TO @FM IN Y.KEY.NAME.OPER
        Y.KEY.NAME = Y.KEY.NAME.OPER<1>

        IF Y.KEY.NAME EQ 'ID' THEN
            Y.KEY.NAME = '@ID'
        END

*ID VALIDATION RULE TO AVOID INPUT IN VERSION WITHOUT AUTO.START.ID OR ID ROUTINE
        IF Y.KEY.NAME EQ '@ID' THEN
*DEBUG
            Y.JS.HAS.ID.FIELD = 2
        END

        LOCATE Y.KEY.NAME IN Y.DYN.MAPPING.IN<5,1> SETTING Y.POS THEN
            Y.DYN.REQUEST.KEY<V.I> = Y.DYN.REQUEST.KEY.TMP<V.I>
            Y.DYN.REQUEST.OFS.KEY<V.I> = Y.DYN.MAPPING.IN<6,Y.POS>
            Y.DYN.REQUEST.OFS.TYPE<V.I> =  Y.DYN.MAPPING.IN<7,Y.POS>

*TO IGNORE STRING DIFERENT THAN FOUND STRING
            IF Y.KEY.NAME NE Y.DYN.MAPPING.IN<5,Y.POS> THEN
                Y.DYN.REQUEST.OFS.KEY<V.I>='*'
                Y.DYN.REQUEST.OFS.TYPE<V.I>='*'
            END
        END
        ELSE
*DEBUG
*Y.ERROR<1> = 1
*Y.ERROR<2> = 'INVALID FIELD, CHECK JSON INPUT MESSAGE, FIELD: <':  Y.KEY.NAME : ">, DON'T EXIT IN ST.L.APAP.JSON.TO.OFS>FIELD.JSON OF MAPPING : " :  Y.DYN.MAPPING.IN<1>  : "<" : Y.DYN.MAPPING.IN<5>  : ">"
*RETURN

            IF Y.KEY.NAME EQ '@ID'  AND Y.MP.HAS.ID.FIELD EQ 1 AND Y.OBJECT.TYPE EQ 'VERSION'THEN
*TO FILL @ID WHEN IS STORE AS ID IN VERSION MAPPING
                Y.DYN.REQUEST.KEY<V.I> = Y.KEY.NAME
                Y.DYN.REQUEST.OFS.KEY<V.I> = Y.KEY.NAME
                Y.DYN.REQUEST.OFS.TYPE<V.I> =  'S'
            END
            ELSE
                Y.DYN.REQUEST.OFS.KEY<V.I>='*'
                Y.DYN.REQUEST.OFS.TYPE<V.I>='*'
            END
            CONTINUE
        END
    NEXT V.I

*ID VALIDATION RULE TO AVOID INPUT IN VERSION WITHOUT AUTO.START.ID OR ID ROUTINE
    IF Y.JS.HAS.ID.FIELD EQ 0 AND Y.MP.HAS.ID.FIELD NE 0 AND Y.OBJECT.TYPE EQ 'VERSION' THEN
        Y.ERROR<1> = 1
        Y.ERROR<2> = 'WHEN THE VERSION INPUT MAPPING<':  Y.DYN.MAPPING.IN<1>  : '> HAS @ID MUST BE SENT IN THE REQUEST'
    END

RETURN
END
